
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КассаККМОтбор        = Параметры.КассаККМ;
	КартаЛояльностиОтбор = Параметры.КартаЛояльности;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КартаЛояльности", КартаЛояльностиОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КартаЛояльностиОтбор));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаККМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

&НаКлиенте
Процедура КартаЛояльностиОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КартаЛояльности", КартаЛояльностиОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КартаЛояльностиОтбор));
	
КонецПроцедуры

#КонецОбласти
