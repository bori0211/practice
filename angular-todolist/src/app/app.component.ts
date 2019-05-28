import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  name: string = 'Seok-tae Kim';

  constructor() {
    console.log(123);
    //this.name = 'Test';
    this.changeName('Jone');
  }

  changeName(name: string): void {
    this.name = name;
  }
}
