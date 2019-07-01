
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	Если Не ПустаяСтрока(ИдентификаторКлиента) Тогда
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Код", ИдентификаторКлиента));
		НовыйФиксированныйМассив = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.РабочееМесто.ПараметрыВыбора = НовыйФиксированныйМассив;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИЗакрыть(Команда)
	
	ОчиститьСообщения();
		
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		Параметры.РабочееМесто = РабочееМесто;
		ОчиститьСообщения();
		СтруктураВозврата = Новый Структура("РабочееМесто", РабочееМесто);
		Закрыть(СтруктураВозврата);
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выберите рабочее место';uk='Виберіть робоче місце'"), РабочееМесто, "РабочееМесто");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти