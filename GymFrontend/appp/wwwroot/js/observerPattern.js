export class Sujeto {
  constructor(htmlInput) {
    this.htmlInput = htmlInput;
    this.observadores = []; // Lista de observadores
  }

  // Método para suscribir un observador
  suscribir(observador) {
    this.observadores.push(observador);
  }
  suscribirVarios(observadores) {
    for (let observador of observadores) {
      this.suscribir(observador);
    }
  }

  // Método para desuscribir un observador
  desuscribir(observador) {
    this.observadores = this.observadores.filter(obs => obs !== observador);
  }

  // Método para notificar a los observadores
  notificar(datos) {
    this.observadores.forEach(observador => observador.actualizar(datos));
  }
  notificarATodosExceptoA(datos) {
    this.observadores.forEach(observer => {
      if (!datos.idInput.includes(observer.htmlInput.id)) {
        observer.actualizar(datos.isDisabled);
      }
    })
  }
  notificarA(datos) {
    this.observadores.filter(observer => datos.idInput.includes(observer.htmlInput.id)).forEach(
      observer => {
        observer.actualizar(datos.isDisabled)
      }
    )
    //this.observadores.find(observer => datos.idInput.includes(observer.htmlInput.id)).actualizar(datos.isDisabled);
  }
  notificarGrupo(datos) {
    this.observadores.forEach(observer => {
      if (observer.htmlInput.name.includes(datos.nameParticle)) {
        observer.actualizar(datos.isDisabled);
      }
    })
  }

}

export class ObservadorSujeto extends Sujeto {
  constructor(htmlInput) {
    super(htmlInput); // Llama al constructor de la clase base (Sujeto)
  }

  // Método que se ejecuta cuando el sujeto notifica un cambio
  actualizar(isDisabled) {
    this.htmlInput.disabled = Boolean(isDisabled);
    // Este observador también notifica a sus propios observadores
    //this.notificar(datos);
  }
}

