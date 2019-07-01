#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокРЦ = Параметры.ДоступныеРабочиеЦентры;
	
	Для каждого ЭлементОтбора Из СписокРЦ Цикл
		Если Параметры.ОтборРабочийЦентр.НайтиПоЗначению(ЭлементОтбора.Значение) <> Неопределено Тогда
			ЭлементОтбора.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
	// Добавим выбранные РЦ, если их нет в доступных
	// Это нужно чтобы "не потерялся отбор", если ключевыми стали другие РЦ
	Для каждого ЭлементОтбора Из Параметры.ОтборРабочийЦентр Цикл
		Если СписокРЦ.НайтиПоЗначению(ЭлементОтбора.Значение) = Неопределено Тогда
			СписокРЦ.Добавить(ЭлементОтбора.Значение, ЭлементОтбора.Представление, Истина);
		КонецЕсли; 
	КонецЦикла; 
	
	СписокРЦ.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОтборРабочийЦентр = Новый СписокЗначений;
	Для каждого ЭлементОтбора Из СписокРЦ Цикл
		Если ЭлементОтбора.Пометка Тогда
			ОтборРабочийЦентр.Добавить(ЭлементОтбора.Значение, ЭлементОтбора.Представление);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОтборРабочийЦентр", ОтборРабочийЦентр);
	
	Закрыть(ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти
