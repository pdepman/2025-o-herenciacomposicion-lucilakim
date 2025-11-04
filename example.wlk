class Aventurero {
  var vida
  var defensa
  const equipamientos = []
  
  // getter
  method equipamientos() = equipamientos

  method recibirAtaque(danio) {
    const danioReal = (danio - defensa).max(0)
    vida -= danioReal
  }
  
  method vida() = vida
  method aumentarVida(cantidad) {
    vida += cantidad
  }

  method aumentarDefensa(cantidad) {
    defensa += cantidad
  }

  method aplicarBuffs() {
    self.equipamientos().forEach({elemento => elemento.aplicarBuff(self)})
  }

}

class Guerrero inherits Aventurero (vida = 1000, 
                                    equipamientos = [
                                        new Espada(),
                                        new Espada(desgaste = 5),
                                        new Armadura(),
                                        new Baston()
                                      ]) {
  var aniosServicio = 10
  
  method fuerzaAtaque() = self.danioEquipamiento() + self.plus()
  
  //  equipamientos.map({ eq => eq.danio() }).sum() // menos declarativa, más algorítmic
  method danioEquipamiento() = equipamientos.sum({ eq => eq.danio() })
  
  method atacar(contrincante) {
    contrincante.recibirAtaque(self.fuerzaAtaque())
  }
  
  method plus() = 100 * aniosServicio
}

class Mago inherits Aventurero {
  var companiero
  
  method atacar(contrincante) {
    companiero.atacar(contrincante)
  }
}

class Clerigo inherits Guerrero {
  override method recibirAtaque(danio) {
    super(danio)
    // es como hacer self.recibirAtaque(danio) pero ejecutando el método de la superclase
    vida += 5
  }
  
  // repite lógica
  // override method fuerzaAtaque() = self.danioEquipamiento() + 50
  override method plus() = 50
}

class Espada inherits Equipamiento {
  var desgaste = 0
  
  method danio() = 100 - desgaste
  
  method afilar() {
    desgaste = 0
  }
} // dos instancias de la misma clase tienen:

// MISMOS atributos
// DISTINTO estado interno
// MISMO comportamiento
// DISTINTA identidad
class Armadura inherits Equipamiento {
  // un sólo objeto
  method danio() = 0
}

// Punto 6
class Baston inherits Equipamiento {
  var cantUsos = 0
  var tipoBaston = new BastonComun()

// Getter
  method tipoBaston() = tipoBaston

// Otros Metodos
  method usar() {
    cantUsos += 1
    self.actualizarTipo()
  }

  method actualizarTipo() {
      if (cantUsos >= 8) { // pongo primero el mas restrictivo para asegurarme que no caiga siempre en el 3
        tipoBaston = new BastonMaza(pesoEnKg = 1)
      } else if (cantUsos >= 3) {
        tipoBaston = new BastonClava(cantClavos = 2)
      } // si no queda en comun
  }

  method danio() {
    // el guerrero cuando pide danio() es por que ataca con el, implicitamente lo usa 
    self.usar() 
    return tipoBaston.danio()
  }
}

class BastonComun {
  method danio() = 10
}

class BastonClava {
  var cantClavos = 2
  method danio() = 12 + cantClavos
}

class BastonMaza {
  var pesoEnKg = 1
  method danio() = 15 * pesoEnKg 
}

// Punto 7 
class Grupo {
  var integrantes = []

  method estaLleno() = integrantes.size() >= 5

  method agregarIntegrante(aventurero) {
    if(self.estaLleno()) {
      throw new DomainException(message = "El grupo esta lleno, solo acepta 5 integrantes")
    }

    integrantes.add(aventurero)
    aventurero.aplicarBuffs()
  }

  // Punto 9
  method ataqueGrupal(contrincante) {
    integrantes.forEach({integrante => integrante.atacar(contrincante)})
  }
}

// Punto 8 
class Equipamiento {
  var buff = null // puede ser buffVida, buffDefensa, o null

  method aplicarBuff(aventurero) {
    if(buff != null) buff.aplicarBuff(aventurero)
  }
}

object buffVida {
  method aplicarBuff(aventurero) {
    aventurero.aumentarVida(20)
  }
}

object buffFortalecimiento {
  method aplicarBuff(aventurero) {
    aventurero.aumentarDefensa(15)
  }
}

const espadaSimple = new Espada()
const espadaDeVida = new Espada(buff = buffVida)
const espadaDeDefensa =  new Espada(buff = buffFortalecimiento)
const armaduraSimple = new Armadura()
const armaduraDeDefensa =  new Armadura(buff = buffFortalecimiento)
const armaduraDeVida = new Armadura(buff = buffVida)
//....

