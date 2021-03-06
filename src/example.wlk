import packs.*

object telefonia{
	const precioMB = 0.10
	const precioSegLlamada = 0.05
	const precioFijo = 1
	
	method cobrarLlamada(cuanto) {
		const pasoLos30 = cuanto - 30
		if(pasoLos30 > 0){
			return precioFijo + pasoLos30*precioSegLlamada
		}
		else{
			return pasoLos30*precioSegLlamada
		}
	}
	method cobrarInternet(mb) = mb * precioMB
	
}

class Linea{
	const numeroTel
	const packActivos = []
	const consumosRealizados = []
	const registroDeudas = []
	var tipo
	
	method costoPromConsumosRealizadosEntre(fechaInicio,fechaFin) {
	const realizadosEntre = self.realizadosEntre(fechaInicio,fechaFin)
	return self.sumarCostoConsumos(realizadosEntre) / realizadosEntre.size()
		}
	
	method sumarCostoConsumos(consumos) = consumos.sum({consumo => consumo.costo()})
	
	method realizadosEntre(fechaInicio,fechaFin) = consumosRealizados.filter({consumo => consumo.estaEntreFechas(fechaInicio,fechaFin)})
	
	method costoTotalConsumosUltimos30() = self.sumarCostoConsumos(self.consumosUltimoMes())
	
	method consumosUltimoMes() {
		 const hoy = new Date()
		 //return consumosRealizados.filter({consumo => consumo.estaEntreFechas(hoy.minusDays(30),hoy)})
		 //REPETICION DE LOGICA, es asi:
		 return self.realizadosEntre(hoy.minusDays(30),hoy)
		 }
	method agregarPack(pack){
		packActivos.add(pack)
		}
	method puedeRealizarConsumo(consumo) = packActivos.any({pack => pack.puedeSatisfacer(consumo)})
	
	method realizarConsumo(consumo){ 
		consumo.afectar(self.ultimoQuePuedaSatisfacer(consumo))
		self.agregarConsumoRealizado(consumo)
		}
	method agregarConsumoRealizado(consumo){
		consumosRealizados.add(consumo)
	}
		
	method ultimoQuePuedaSatisfacer(consumo) = packActivos.reverse().findOrElse({pack => pack.puedeSatisfacer(consumo)},{ tipo.noSeEncontroPack(self,consumo)})
	
	method realizarLimpiezaPacks() {
		packActivos.removeAllSuchThat({pack => pack.tieneVigencia().negate()})
	}
	method agregarDeuda(deuda){
		registroDeudas.add(deuda)
	}
}

object comun{
	method noSeEncontroPack(linea,consumo) {
		self.error("No se encontro ningun pack que pueda satisfacer al cambio")
		}
}
object black{
	method noSeEncontroPack(linea,consumo){
		linea.agregarConsumoRealizado(consumo)
		linea.agregarDeuda(consumo.costo())
	}
}
object platinum{
	method noSeEncontroPack(linea,consumo){
		linea.agregarConsumoRealizado(consumo)
	}
}

class Consumo{
	var fecha 
	
	method estaEntreFechas(fechaInicio,fechaFin) = fecha.between(fechaInicio,fechaFin)
	
	method puedeConsumirse(tope) = self.costo() < tope 
	
	//podria hacerse mejor
	method seHaceElFinde() = fecha.dayOfWeek() == friday or fecha.dayOfWeek() == saturday or fecha.dayOfWeek() == sunday
	
	method costo()
}

class ConsumoLlamada inherits Consumo {
	var tiempo
	
	override method costo() = telefonia.cobrarLlamada(tiempo)
	
	method esDeLlamada() = true
	
	method afectarPack(pack){
		pack.afectar(self.costo())
	}
} 

class ConsumoInternet inherits Consumo {
	var mb
	
	method esDeLlamada() = false
	
	override method costo() = telefonia.cobrarInternet(mb)
	
	method mbConsumidos() = mb
	
	method afectarPack(pack){
		pack.afectar(mb)
	}
	method menosDeUnMB() = mb <= 0.1
	
}


