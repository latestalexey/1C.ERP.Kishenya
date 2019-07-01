#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	ПодсистемаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба");
	Если Не ПодсистемаСуществует Тогда
		Если Значение Тогда
			ВызватьИсключение НСтр("ru='Нельзя установить значение ИспользоватьМуниципальнуюСлужбу';uk='Не можна встановити значення ИспользоватьМуниципальнуюСлужбу'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодсистемаСуществует Тогда
		ИспользоватьГосударственнуюСлужбу = Константы.ИспользоватьГосударственнуюСлужбу.Получить();
		Если Значение И ИспользоватьГосударственнуюСлужбу Тогда
			ВызватьИсключение НСтр("ru='В программе уже ведется расчет денежного содержания Государственных служащих, не допускается использовать одновременно расчет денежного содержания Государственных и Муниципальных служащих';uk='У програмі вже ведеться розрахунок грошового утримання Державних службовців, не допускається використовувати одночасно розрахунок грошового утримання Державних і Муніципальних службовців'");	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли