import example.*

class Pack {
	
	method puedeSatisfacer(consumo) = self.esCompatible(consumo) and self.puedeConsumir(consumo) 
	
	method puedeConsumir(consumo)
	
	method esCompatible(consumo)
}


class PackMBlibres inherits Pack{
	const mb
	
	override method esCompatible(consumo) = consumo.esDeLlamada().negate()
	
	override method puedeConsumir(consumo) = consumo.puedeConsumirse(telefonia.cobrarInternet(mb))
}

class PackCredito inherits Pack{
	const credito
	
	override method esCompatible(consumo) = true
	
	override method puedeConsumir(consumo) = consumo.puedeConsumirse(credito)
	
}

class PackInternetGratisFindes inherits Pack{
	
	override method esCompatible(consumo) = consumo.esDeLlamada().negate()
	
	override method puedeConsumir(consumo) = consumo.seHaceElFinde()
}

class PackLlamadasGratis inherits Pack{
	var llamadasGratis
	
	override method esCompatible(consumo) = consumo.esDeLlamada()
	
	override method puedeConsumir(consumo) = llamadasGratis > 0
}
