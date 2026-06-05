import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BukiApiService {
  private baseUrl = 'http://localhost:3000';

  constructor(private http: HttpClient) {}

  getHealth(): Observable<any> {
    return this.http.get(`${this.baseUrl}/api/health`);
  }

  getServices(): Observable<any> {
    return this.http.get(`${this.baseUrl}/api/services`);
  }

  createService(serviceData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/api/services`, serviceData);
  }

  getBookings(): Observable<any> {
    return this.http.get(`${this.baseUrl}/api/bookings`);
  }

  createBooking(bookingData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/api/bookings`, bookingData);
  }
}
