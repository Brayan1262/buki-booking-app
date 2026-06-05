import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { BukiApiService } from './services/buki-api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Buki Booking App';
  
  // Servicios
  services: any[] = [];
  serviceForm = {
    name: '',
    description: '',
    price: null as number | null,
    duration: null as number | null
  };
  serviceSuccessMessage = '';
  serviceErrorMessage = '';
  loadingServices = false;
  savingService = false;

  // Reservas
  bookings: any[] = [];
  bookingForm = {
    client_name: '',
    client_email: '',
    service_id: '',
    booking_date: '',
    booking_time: ''
  };
  bookingSuccessMessage = '';
  bookingErrorMessage = '';
  loadingBookings = false;
  savingBooking = false;
  
  // API Status (Para el dashboard)
  apiStatus = 'Pendiente';
  apiOnline = false;

  constructor(private bukiApi: BukiApiService) {}

  ngOnInit() {
    this.checkApiStatus();
    this.loadServices();
    this.loadBookings();
  }

  checkApiStatus() {
    this.bukiApi.getHealth().subscribe({
      next: () => {
        this.apiStatus = 'Conectado';
        this.apiOnline = true;
      },
      error: () => {
        this.apiStatus = 'Sin conexión';
        this.apiOnline = false;
      }
    });
  }

  // ---- Lógica de Servicios ----

  loadServices() {
    this.loadingServices = true;
    this.bukiApi.getServices().subscribe({
      next: (data) => {
        this.services = data;
        this.loadingServices = false;
      },
      error: (err) => {
        console.error('Error cargando servicios:', err);
        this.serviceErrorMessage = 'No se pudo conectar con el servidor. Verifica que el backend esté ejecutándose en http://localhost:3000.';
        this.loadingServices = false;
      }
    });
  }

  validateServiceForm(): boolean {
    this.serviceErrorMessage = '';
    this.serviceSuccessMessage = '';
    
    if (!this.serviceForm.name || this.serviceForm.name.trim() === '') {
      this.serviceErrorMessage = 'El nombre del servicio es obligatorio.';
      return false;
    }
    
    if (this.serviceForm.price === null || this.serviceForm.price < 0) {
      this.serviceErrorMessage = 'El precio debe ser un número mayor o igual a 0.';
      return false;
    }
    
    if (this.serviceForm.duration === null || this.serviceForm.duration <= 0) {
      this.serviceErrorMessage = 'La duración debe ser un número mayor a 0.';
      return false;
    }
    
    return true;
  }

  createService() {
    if (!this.validateServiceForm()) {
      return;
    }
    
    this.savingService = true;
    this.bukiApi.createService(this.serviceForm).subscribe({
      next: (res) => {
        this.serviceSuccessMessage = 'Servicio registrado correctamente.';
        this.resetServiceForm();
        this.loadServices();
        this.savingService = false;
        
        // Limpiar mensaje de éxito después de 5 segundos
        setTimeout(() => this.serviceSuccessMessage = '', 5000);
      },
      error: (err) => {
        console.error('Error creando servicio:', err);
        this.serviceErrorMessage = err.error?.message || 'Error al crear el servicio.';
        this.savingService = false;
      }
    });
  }

  resetServiceForm() {
    this.serviceForm = {
      name: '',
      description: '',
      price: null,
      duration: null
    };
  }

  // ---- Lógica de Reservas ----

  loadBookings() {
    this.loadingBookings = true;
    this.bukiApi.getBookings().subscribe({
      next: (data) => {
        this.bookings = data;
        this.loadingBookings = false;
      },
      error: (err) => {
        console.error('Error cargando reservas:', err);
        this.bookingErrorMessage = 'No se pudo conectar con el servidor. Verifica que el backend esté ejecutándose en http://localhost:3000.';
        this.loadingBookings = false;
      }
    });
  }

  isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  validateBookingForm(): boolean {
    this.bookingErrorMessage = '';
    this.bookingSuccessMessage = '';
    
    if (!this.bookingForm.client_name || this.bookingForm.client_name.trim() === '') {
      this.bookingErrorMessage = 'El nombre del cliente es obligatorio.';
      return false;
    }
    
    if (!this.bookingForm.client_email || !this.isValidEmail(this.bookingForm.client_email)) {
      this.bookingErrorMessage = 'El correo del cliente no es válido.';
      return false;
    }

    if (!this.bookingForm.service_id) {
      this.bookingErrorMessage = 'Debe seleccionar un servicio.';
      return false;
    }
    
    if (!this.bookingForm.booking_date) {
      this.bookingErrorMessage = 'La fecha de reserva es obligatoria.';
      return false;
    }

    if (!this.bookingForm.booking_time) {
      this.bookingErrorMessage = 'La hora de reserva es obligatoria.';
      return false;
    }
    
    return true;
  }

  createBooking() {
    if (!this.validateBookingForm()) {
      return;
    }
    
    this.savingBooking = true;
    this.bukiApi.createBooking(this.bookingForm).subscribe({
      next: (res) => {
        this.bookingSuccessMessage = 'Reserva registrada correctamente.';
        this.resetBookingForm();
        this.loadBookings();
        this.savingBooking = false;
        
        setTimeout(() => this.bookingSuccessMessage = '', 5000);
      },
      error: (err) => {
        console.error('Error creando reserva:', err);
        this.bookingErrorMessage = err.error?.message || 'Error al crear la reserva.';
        this.savingBooking = false;
      }
    });
  }

  resetBookingForm() {
    this.bookingForm = {
      client_name: '',
      client_email: '',
      service_id: '',
      booking_date: '',
      booking_time: ''
    };
  }
}
