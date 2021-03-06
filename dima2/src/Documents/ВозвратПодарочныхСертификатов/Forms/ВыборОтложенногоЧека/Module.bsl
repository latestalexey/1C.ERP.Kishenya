
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КассаККМОтбор = Параметры.КассаККМ;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаККМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

#КонецОбласти
