
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВызватьИсключение НСтр("ru='Данный регистр является служебным, поэтому доступ к его данным запрещен.';uk='Даний регістр є службовим, тому доступ до його даних заборонений.'");
КонецПроцедуры
