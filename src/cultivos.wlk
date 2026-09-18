import wollok.game.*
import granja.*

class Maiz {
	var property position = game.at(1, 1)
	var adulta = false

	method image() {
		return if (adulta) "maiz_adulto.png" else "maiz_bebe.png"
	}

	method regar(cultivo) {
		if (not adulta) {
			adulta = true
			game.removeVisual(self)
			game.addVisual(self)
		}
	}

	method esAdulta() {
		return adulta
	}
}

class Trigo {
	var property position = game.at(1, 1)
	var etapaEvolucion = 0
	method image() {
		return if (etapaEvolucion == 1) "trigo_1.png" else if (etapaEvolucion == 2) "trigo_2.png" else if (etapaEvolucion == 3) "trigo_3.png" else  "trigo_0.png"
	}

	method avanzarEtapa() {
	  etapaEvolucion = etapaEvolucion + 1
	}

	method regar(cultivo) {
	  game.removeVisual(self)
	  self.avanzarEtapa()
	  game.addVisual(self)
	}
}

class Tomaco {
	var property position = game.at(1, 1)
	method image() {
		return "tomaco.png"
	}

	method regar(cultivo) {
		const nuevaFila = if (position.y() == game.height() - 1) 0 else position.y() + 1
		const nuevaPosicion = game.at(position.x(), nuevaFila)
		if (not granja.hayCultivo(nuevaPosicion)) {
			position = nuevaPosicion
		}
	}
}