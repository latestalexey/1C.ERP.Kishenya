
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	СписокТиповКарт = Неопределено;

	СуммаВременная = 0;
	Если Параметры.Свойство("Сумма", СуммаВременная)
	   И СуммаВременная > 0 Тогда
		Сумма = СуммаВременная;
	Иначе
		Сумма = 0;
	КонецЕсли;

	времПределСуммы = 0;
	Если Параметры.Свойство("ПределСуммы", времПределСуммы)
	   И времПределСуммы > 0 Тогда
		Элементы.Сумма.МаксимальноеЗначение = времПределСуммы;
	Иначе
		Элементы.Сумма.МаксимальноеЗначение = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапретРедактированияСуммы") Тогда
		Элементы.Сумма.ТолькоПросмотр = Параметры.ЗапретРедактированияСуммы;
	КонецЕсли;
	
	Если Параметры.Свойство("СписокТиповКарт", СписокТиповКарт)
	   И ТипЗнч(СписокТиповКарт) = Тип("СписокЗначений")
	   И СписокТиповКарт. Количество() > 0 Тогда
		Для Каждого СтрокаСписка Из СписокТиповКарт Цикл
			Элементы.ТипКарты.СписокВыбора.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
		КонецЦикла;
		Элементы.ТипКарты.Видимость = Истина;
	КонецЕсли;
	
	Элементы.НомерКарты.Видимость            = Ложь;
	Элементы.НомерКарты.ТолькоПросмотр       = Истина;
	Элементы.НомерКарты.РедактированиеТекста = Ложь;

	Если Параметры.Свойство("ПоказыватьНомерКарты", ПоказыватьНомерКарты) Тогда
		Если ПоказыватьНомерКарты Тогда
			Элементы.НомерКарты.Видимость            = Истина;
			Элементы.НомерКарты.ТолькоПросмотр       = Ложь;
			Элементы.НомерКарты.РедактированиеТекста = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Сумма.ТолькоПросмотр Тогда
		Элементы.Сумма.АктивизироватьПоУмолчанию = Ложь;
		Если Элементы.ТипКарты.Видимость И Элементы.ТипКарты.СписокВыбора.Количество() > 1 Тогда
			Элементы.ТипКарты.АктивизироватьПоУмолчанию = Истина;
		ИначеЕсли Элементы.НомерКарты.Видимость Тогда
			Элементы.НомерКарты.АктивизироватьПоУмолчанию = Истина;
		Иначе
			Элементы.ВыполнитьОперацию.АктивизироватьПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("УказатьДополнительныеДанные") Тогда
		УказатьДополнительныеДанные = Истина;
	КонецЕсли;
	
	Элементы.ГруппаРучнойВводДанных.Видимость = УказатьДополнительныеДанные;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьДополнительныеДанныеПриИзменении(Элемент)

	Элементы.ГруппаРучнойВводДанных.Видимость = УказатьДополнительныеДанные;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию(Команда)
	
	Ошибки = "";
	
	ОчиститьСообщения();
	
	Если Сумма = 0 Тогда
		Ошибки = НСтр("ru='Платеж не может быть осуществлен на нулевую сумму.';uk='Платіж не може бути здійснений на нульову суму.'");
	КонецЕсли;
	
	Если ПоказыватьНомерКарты И Не ЗначениеЗаполнено(НомерКарты) Тогда
		Ошибки = Ошибки + ?(ПустаяСтрока(Ошибки),"",Символы.ПС) + НСтр("ru='Платеж не может быть осуществлен без номера карты.';uk='Платіж не може бути здійснений без номера карти.'");
	КонецЕсли;
	
	Если ПустаяСтрока(Ошибки) Тогда
		Если Не УказатьДополнительныеДанные Тогда
			СсылочныйНомер = "";
			НомерЧека      = "";
		КонецЕсли;
		
		СтруктураВозврата = Новый Структура();
		СтруктураВозврата.Вставить("Сумма"         , Сумма);
		СтруктураВозврата.Вставить("ДанныеКарты"   , "");
		СтруктураВозврата.Вставить("СсылочныйНомер", СсылочныйНомер);
		СтруктураВозврата.Вставить("ТипКарты"      , ТипКарты);
		СтруктураВозврата.Вставить("НомерКарты"    , НомерКарты);
		СтруктураВозврата.Вставить("НомерЧека"     , НомерЧека);
		
		Закрыть(СтруктураВозврата);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибки,,"НомерКарты");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СуммаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)

	Если Элементы.Сумма.МаксимальноеЗначение <> Неопределено
	   И Элементы.Сумма.МаксимальноеЗначение < Число(Текст) Тогда
	   
		СтандартнаяОбработка = Ложь;
		СтруктураЗначения = Новый Структура;
		СтруктураЗначения.Вставить("Предупреждение", НСтр("ru='Сумма оплаты по карте превышает необходимую безналичную оплату.
        |Значение будет изменено на максимально возможное.'
        |;uk='Сума оплати по карті перевищує необхідну безготівкову оплату.
        |Значення буде змінено на максимально можливе.'"));
		СтруктураЗначения.Вставить("Значение", Формат(Элементы.Сумма.МаксимальноеЗначение, "ЧЦ=15; ЧДЦ=2; ЧН=0; ЧГ=0; ЧО=1"));
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(СтруктураЗначения);
		ДанныеВыбора = СписокЗначений;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
