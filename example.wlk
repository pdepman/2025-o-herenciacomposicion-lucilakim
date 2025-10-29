class Aventurero {
  var vida
  var defensa
  
  method recibirAtaque(danio) {
    vida -= danio - defensa
  }
  
  method vida() = vida
}

class Guerrero inherits Aventurero (vida = 1000) {
  var aniosServicio = 10
  const equipamientos = [
    new Espada(),
    new Espada(desgaste = 5),
    armadura,
    new BastonComun()
  ]
  
  method fuerzaAtaque() = self.danioEquipamiento() + self.plus()
  
  //  equipamientos.map({ eq => eq.danio() }).sum() // menos declarativa, más algorítmic
  method danioEquipamiento() = equipamientos.sum({ eq => eq.danio() })
  
  method atacar(contricante) {
    contricante.recibirAtaque(self.fuerzaAtaque())
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

class Espada {
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
object armadura {
  // un sólo objeto
  method danio() = 0
}

class BastonComun {
  method danio() = 10
}
