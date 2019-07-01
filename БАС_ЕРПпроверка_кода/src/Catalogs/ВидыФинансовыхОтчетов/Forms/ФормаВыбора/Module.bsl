
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ИсключитьОтчеты") Тогда
		ИсключитьОтчеты = Параметры.ИсключитьОтчеты;
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеРавно;
		Если ТипЗнч(ИсключитьОтчеты) = Тип("СписокЗначений")
			ИЛИ ТипЗнч(ИсключитьОтчеты) = Тип("Массив") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеВСписке;
		КонецЕсли;
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ссылка", ИсключитьОтчеты, ВидСравненияОтбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
