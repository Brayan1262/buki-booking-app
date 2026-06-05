import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BukiMobilePreviewApp());
}

class BukiMobilePreviewApp extends StatelessWidget {
  const BukiMobilePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buki Mobile Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F5FC), // Fondo de Buki
        primaryColor: const Color(0xFF8F79BD), // Morado principal
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8F79BD),
          primary: const Color(0xFF8F79BD),
          secondary: const Color(0xFFB9A7D8), // Lila suave
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5F4B8B), // Morado oscuro
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ATENCIÓN: Si pruebas en emulador Android nativo, cambia localhost por 10.0.2.2
  // Para flutter run -d chrome, funciona 'http://localhost:3000/api'
  final String apiUrl = 'http://localhost:3000/api'; 
  
  List<dynamic> services = [];
  List<dynamic> bookings = [];
  bool isLoading = true;
  String errorMsg = '';
  bool apiOnline = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
      apiOnline = false;
    });

    try {
      final servicesRes = await http.get(Uri.parse('$apiUrl/services'));
      final bookingsRes = await http.get(Uri.parse('$apiUrl/bookings'));

      if (servicesRes.statusCode == 200 && bookingsRes.statusCode == 200) {
        setState(() {
          services = json.decode(servicesRes.body);
          bookings = json.decode(bookingsRes.body);
          apiOnline = true;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Error cargando datos del servidor.';
          apiOnline = false;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'No se pudo conectar con el backend. Verifica que Node.js esté ejecutándose en http://localhost:3000.';
        apiOnline = false;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buki Mobile Preview', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
            tooltip: 'Actualizar',
          )
        ],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8F79BD)))
          : RefreshIndicator(
              onRefresh: fetchData,
              color: const Color(0xFF8F79BD),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildHeroSection(),
                  if (errorMsg.isNotEmpty) _buildErrorCard(),
                  if (errorMsg.isEmpty) ...[
                    _buildSummaryCards(),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Servicios Registrados'),
                    services.isEmpty 
                      ? _buildEmptyState('No hay servicios registrados todavía.')
                      : _buildServicesList(),
                        
                    const SizedBox(height: 32),
                    
                    _buildSectionTitle('Reservas Recientes'),
                    bookings.isEmpty 
                      ? _buildEmptyState('No hay reservas registradas todavía.')
                      : _buildBookingsList(),
                    const SizedBox(height: 40),
                  ]
                ],
              ),
            ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8F79BD), Color(0xFF5F4B8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'buki',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5F4B8B),
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Reserva tu cita\nen segundos.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Vista móvil opcional de servicios y reservas.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Consulta servicios disponibles y reservas registradas desde una experiencia móvil simple.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Expanded(child: _buildSmallSummaryCard('Servicios', services.length.toString(), Icons.content_cut)),
          const SizedBox(width: 12),
          Expanded(child: _buildSmallSummaryCard('Reservas', bookings.length.toString(), Icons.calendar_today)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF5F4B8B).withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Icon(apiOnline ? Icons.check_circle : Icons.error, 
                    color: apiOnline ? const Color(0xFF6FCF97) : const Color(0xFFEB5757), size: 24),
                  const SizedBox(height: 8),
                  Text('API', style: TextStyle(fontSize: 12, color: const Color(0xFF5E5873).withOpacity(0.7), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(apiOnline ? 'Online' : 'Error', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF2F2A3D))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallSummaryCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF5F4B8B).withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8F79BD), size: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: const Color(0xFF5E5873).withOpacity(0.7), fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF2F2A3D))),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFEB5757).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEB5757).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEB5757), size: 40),
            const SizedBox(height: 12),
            Text(
              errorMsg, 
              textAlign: TextAlign.center, 
              style: const TextStyle(color: Color(0xFFEB5757), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2F2A3D)),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB9A7D8).withOpacity(0.5), width: 2),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 48, color: const Color(0xFFB9A7D8).withOpacity(0.8)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF5E5873), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: services.map((s) => _buildServiceCard(s)).toList(),
      ),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    // Formatear precio
    final double price = service['price'] is String ? double.parse(service['price']) : service['price'].toDouble();
    final String formattedPrice = price.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF5F4B8B).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFF8F79BD), width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F79BD).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.content_cut, color: Color(0xFF8F79BD), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              service['name'], 
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2F2A3D), fontSize: 16),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8F79BD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'S/ $formattedPrice', 
                              style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF8F79BD), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service['description'] ?? 'Sin descripción', 
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF5E5873), fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F5FC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFB9A7D8).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_filled, size: 14, color: Color(0xFF8F79BD)),
                                const SizedBox(width: 6),
                                Text('${service['duration']} min', style: const TextStyle(color: Color(0xFF5E5873), fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: bookings.map((b) => _buildBookingCard(b)).toList(),
      ),
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    final bool isConfirmed = booking['status'] == 'confirmed';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF5F4B8B).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['client_name'], 
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF2F2A3D)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isConfirmed ? const Color(0xFF6FCF97) : const Color(0xFFF2C94C),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: (isConfirmed ? const Color(0xFF6FCF97) : const Color(0xFFF2C94C)).withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
                    ]
                  ),
                  child: Text(
                    isConfirmed ? 'Confirmada' : 'Pendiente',
                    style: TextStyle(color: isConfirmed ? Colors.white : const Color(0xFF2F2A3D), fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 14, color: Color(0xFFB9A7D8)),
                const SizedBox(width: 6),
                Expanded(child: Text(booking['client_email'], style: const TextStyle(color: Color(0xFF5E5873), fontSize: 13, fontWeight: FontWeight.w500))),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFF8F5FC), thickness: 2),
            ),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8F79BD).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8F79BD).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFF8F79BD), shape: BoxShape.circle),
                    child: const Icon(Icons.design_services, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking['service_name'], style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2F2A3D), fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FC),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFB9A7D8).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 16, color: Color(0xFF8F79BD)),
                  const SizedBox(width: 8),
                  Text(
                    booking['booking_date'].toString().substring(0,10),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2F2A3D), fontSize: 13),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('|', style: TextStyle(color: Color(0xFFB9A7D8), fontWeight: FontWeight.w900)),
                  ),
                  const Icon(Icons.access_time_filled, size: 16, color: Color(0xFF8F79BD)),
                  const SizedBox(width: 8),
                  Text(
                    booking['booking_time'],
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2F2A3D), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
