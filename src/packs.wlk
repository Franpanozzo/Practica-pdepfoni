import example.*

class Pack {
	const vigencia
	
	method puedeSatisfacer(consumo) = self.tieneVigencia() and self.esCompatible(consumo) and self.puedeConsumir(consumo) 
	
	method tieneVigencia() {
		const hoy = new Date()
		return hoy > vigencia
	}
	method puedeConsumir(consumo)
	
	method esCompatible(consumo)
	
}


class PackMBlibres inherits Pack{
	var mb
	
	override method esCompatible(consumo) = consumo.esDeLlamada().negate()
	
	override method puedeConsumir(consumo) = consumo.puedeConsumirse(telefonia.cobrarInternet(mb))
	
	method afectar(mbComidos){
		mb -= mbComidos
	}
}

class PackMBPlusPlus inherits PackMBlibres{
	override method puedeConsumir(consumo) = super(consumo) or consumo.menosDeUnMB()
}


class PackCredito inherits Pack{
	var credito
	
	override method esCompatible(consumo) = true
	
	override method puedeConsumir(consumo) = consumo.puedeConsumirse(credito)
	
	method afectar(creditoComido){
		credito -= creditoComido
	}
}

class PackInternetGratisFindes inherits Pack{
	
	override method esCompatible(consumo) = consumo.esDeLlamada().negate()
	
	override method puedeConsumir(consumo) = consumo.seHaceElFinde()
	
	method afectar(){}
}

class PackLlamadasGratis inherits Pack{
	var llamadasGratis
	
	override method esCompatible(consumo) = consumo.esDeLlamada()
	
	override method puedeConsumir(consumo) = llamadasGratis > 0
	
	method afectar(){}
}
