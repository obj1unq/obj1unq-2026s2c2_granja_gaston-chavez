import wollok.game.*
import granja.*

class Maiz {
	var property position = game.at(1, 1)
	var adulta = false

	method image() {
		return if (self.esAdulta()) "maiz_adulto.png" else "maiz_bebe.png"
	}

	method regar(cultivo) {
		if (not self.esAdulta()) {
			adulta = true
			game.removeVisual(self)
			game.addVisual(self)
		}
	}

	method esAdulta() {
		return adulta
	}

	method estaListaParaCosechar() {
		return self.esAdulta()
	}

	method cosechar(cultivo) { if(self.estaListaParaCosechar()) game.removeVisual(self) }

	method oroPorPlanta() {
	  return 150
	}
}

class Trigo {
	var property position = game.at(1, 1)
	var property etapaEvolucion = 0
	method image() {
		return if (etapaEvolucion == 1) "trigo_1.png" else if (etapaEvolucion == 2) "trigo_2.png" else if (etapaEvolucion == 3) "trigo_3.png" else  "trigo_0.png"
	}

	method avanzarEtapa() {
	  etapaEvolucion = etapaEvolucion + 1
	}
	method estaListaParaCosechar() {
		return etapaEvolucion >= 2
	}

	method regar(cultivo) {
	  game.removeVisual(self)
	  self.avanzarEtapa()
	  game.addVisual(self)
	}

	method cosechar(cultivo) { if (self.estaListaParaCosechar()) game.removeVisual(self) }

	method oroPorPlanta() { return (etapaEvolucion - 1) * 100 }
}

class Tomaco {
	var property position = game.at(1, 1)
	method image() {
		return "tomaco.png"
	}
	method estaListaParaCosechar() {
		return true
	}

	method regar(cultivo) {
		const nuevaFila = if (position.y() == game.height() - 1) 0 else position.y() + 1 //el tablero es de 0 a 9 celdas, si la posicion del cultivo es 9, le pregunto a la altura 10-9, si es verdad, bajo a cero porque ya estaba en el borde
		const nuevaPosicion = game.at(position.x(), nuevaFila)
		if (not granja.hayCultivo(nuevaPosicion)) { //si no hay mercado, actualizo a la nueva posicion, en caso contrario me quedo en donde estoy
			position = nuevaPosicion
		}
	}

	method cosechar(cultivo) { if (self.estaListaParaCosechar()) game.removeVisual(self) }

	method oroPorPlanta() {
	  return 80
	}
}