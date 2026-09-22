import wollok.game.*

object femenino{
	method prefijo() {
		return "f"
	}
	method otro() {
		return masculino
	}
}
object masculino{
	method prefijo() {
		return "m"
	}
	method otro() {
		return femenino
	}
}



object personaje {
	var property genero = femenino
	var property position = game.center()
	const propiedad = granja
	var property moneda = 0 
	
	method  image() {
		return genero.prefijo() + "-player-" + self.estado() + ".png"
	} 
	method estado() {
		return if (self.estaSobreAlgo())  "abajo" else "normal" 
	}
	method estaSobreAlgo() {
		return not game.colliders(self).isEmpty()
	}
	method cambiarGenero() {
		genero = genero.otro()
	}

	method plantar(cultivo) {
		propiedad.plantar(cultivo, self.position())
	}

	method regar() {
	  self.validarSiPuedeRegar()
	  game.colliders(self).forEach({cultivo => cultivo.regar(self)})
	} 

	method validarSiPuedeRegar() {
	  if (not propiedad.hayCultivo(position)) {
		self.error("no tengo nada para regar")
	  }
	}

	method cosechar() {
	  self.validarSiPuedeCosechar()
	  game.colliders(self).forEach({cultivo => granja.cosechar(cultivo)})
	}
	
	method validarSiPuedeCosechar() {
	  if (not propiedad.hayCultivo(position)) {
		self.error("no hay planta cultivada")
	  }
	  game.colliders(self).forEach({cultivo => if (not cultivo.estaListaParaCosechar()) {
		self.error("la planta no esta lista para cosechar")
	  }})
	}

	method oroDeLaVenta() {
	  return propiedad.cultivosCosechados().sum({cultivo => cultivo.oroPorPlanta()})
	}

	method vender() {
	  self.validarSiEstaEnElMercado()
	  moneda = moneda + self.oroDeLaVenta()
	  self.plantasParaVender().clear()
	}

	method validarSiEstaEnElMercado() {
	  if (position != mercado.position()) {
		self.error("no estoy en el mercado")
	  }
	}

	method plantasParaVender() {
	  return propiedad.cultivosCosechados()
	}

	//method cuantoPuedoVender3() {
  	//  return "hola"
	//}

	method text() {
	  return "Oro acumulado: " + moneda
	} 

	method cuantoPuedoVender() {
	  return "Tengo " + propiedad.cultivosCosechados().size() + " planta para vender por " + self.oroDeLaVenta() + " monedas"
	}

	//method cuantoPuedoVender2() {
	//  game.say(self, "Tengo " + propiedad.cultivosCosechados().size() + "planta para vender por " + self.oroDeLaVenta() + " monedas")
	//} no anda
}

object mercado {
	const property position = game.at(5,5)
	const property image = "mercado.png"
}

object granja {
	const property cultivos = #{}
	const property cultivosCosechados = #{}
	
	method cultivosPlantados() {
		return cultivos
	}

	method plantar(cultivo, position) {
		self.validarPlantar(cultivo, position)
		cultivo.position(position)
		cultivos.add(cultivo)
		game.addVisual(cultivo)
	}
	method validarPlantar(cultivo, position) {
		if (not self.puedePlantar(cultivo, position)) {
			self.error("No se puede plantar")
		}
	}
	method puedePlantar(cultivo, position) {
		return not cultivos.contains(cultivo) and not self.hayCultivo(position)
	}
	method hayCultivo(position) {
		return position == mercado.position() or cultivos.any({cultivo => cultivo.position() == position})
		//revisa si la posicion en la que estoy, es el mercado o si hay algun cultivo en la celda actual
	}
	method cosechar(cultivo) {
		cultivo.cosechar(self)
		cultivos.remove(cultivo)
		cultivosCosechados.add(cultivo)
	}
}