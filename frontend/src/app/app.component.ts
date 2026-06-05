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
  
  // API Status (Para el dashboard)
  apiStatus = 'Pendiente de conexión';

  constructor(private bukiApi: BukiApiService) {}

  ngOnInit() {
    this.checkApiStatus();
    this.loadServices();
  }

  checkApiStatus() {
    this.bukiApi.getHealth().subscribe({
      next: () => this.apiStatus = 'Conectado',
      error: () => this.apiStatus = 'Desconectado'
    });
  }

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
}
