
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДобавляемыеНачисленияПриоритетВыше <> Неопределено Тогда 
		ДобавляемыеНачисленияПриоритетВыше.ЗагрузитьЗначения(Параметры.ДобавляемыеНачисленияПриоритетВыше);
		УдаляемыеНачисленияПриоритетВыше.ЗагрузитьЗначения(Параметры.УдаляемыеНачисленияПриоритетВыше);
	КонецЕсли;
	
	Если Параметры.ДобавляемыеНачисленияПриоритетНиже <> Неопределено Тогда 
		ДобавляемыеНачисленияПриоритетНиже.ЗагрузитьЗначения(Параметры.ДобавляемыеНачисленияПриоритетНиже);
		УдаляемыеНачисленияПриоритетНиже.ЗагрузитьЗначения(Параметры.УдаляемыеНачисленияПриоритетНиже);
	КонецЕсли;
	
	ОтображатьСтраницы = ДобавляемыеНачисленияПриоритетВыше.Количество() > 0 И ДобавляемыеНачисленияПриоритетНиже.Количество() > 0;
	
	Если Не ОтображатьСтраницы Тогда 
		Элементы.Страницы.ТекущаяСтраница = ?(ДобавляемыеНачисленияПриоритетВыше.Количество() > 0, Элементы.СтраницаПриоритетВыше, Элементы.СтраницаПриоритетНиже);
	КонецЕсли;
	
	УстановитьОтображениеКнопокКоманднойПанели();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ОтображатьСтраницы И Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПриоритетВыше Тогда 
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПриоритетНиже;
		УстановитьОтображениеКнопокКоманднойПанели();
		
	Иначе 
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("ДействиеПриоритетВыше");
		ПараметрыЗакрытия.Вставить("ДействиеПриоритетНиже");
		
		Если ДобавляемыеНачисленияПриоритетВыше.Количество() <> 0 Тогда 
			ПараметрыЗакрытия.ДействиеПриоритетВыше = ?(ДействиеПриоритетВыше = 0, "Добавить", "Удалить");
		КонецЕсли;
		
		Если ДобавляемыеНачисленияПриоритетНиже.Количество() <> 0 Тогда 
			ПараметрыЗакрытия.ДействиеПриоритетНиже = ?(ДействиеПриоритетНиже = 0, "Добавить", "Удалить");
		КонецЕсли;
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПриоритетВыше;
	УстановитьОтображениеКнопокКоманднойПанели();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтображениеКнопокКоманднойПанели()
	
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если Не ОтображатьСтраницы Тогда 
		Элементы.Назад.Видимость = Ложь;
		Элементы.ОК.Заголовок = НСтр("ru='ОК';uk='ОК'");
		Заголовок = ?(ТекущаяСтраница = Элементы.СтраницаПриоритетВыше, 
			НСтр("ru='Начисления, приоритет которых выше';uk='Нарахування, пріоритет яких вище'"), НСтр("ru='Начисления, приоритет которых ниже';uk='Нарахування, пріоритет яких нижче'"));
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПриоритетВыше Тогда 
		Элементы.Назад.Видимость = Ложь;
		Элементы.ОК.Заголовок = НСтр("ru='Далее >';uk='Далі >'");
		Заголовок = НСтр("ru='Начисления, приоритет которых выше';uk='Нарахування, пріоритет яких вище'");
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПриоритетНиже Тогда 
		Элементы.Назад.Видимость = Истина;
		Элементы.ОК.Заголовок = НСтр("ru='ОК';uk='ОК'");
		Заголовок = НСтр("ru='Начисления, приоритет которых ниже';uk='Нарахування, пріоритет яких нижче'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

