
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Объект.ВыводДанныхОТоварномСоставе) Тогда
		Объект.ВыводДанныхОТоварномСоставе 
			= Метаданные.Документы.ТранспортнаяНакладная.Реквизиты.ВыводДанныхОТоварномСоставе.ЗначениеЗаполнения;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ОчиститьСообщения();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ТранспортнаяНакладная");
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если Объект.ПометкаУдаления Тогда
		Оповестить("Запись_ТранспортнаяНакладная");
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВодительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбранноеЗначение.Свойство("Водитель", 				Объект.Водитель);
	ВыбранноеЗначение.Свойство("УдостоверениеСерия", 	Объект.УдостоверениеСерия);
	ВыбранноеЗначение.Свойство("УдостоверениеНомер",	Объект.УдостоверениеНомер);
КонецПроцедуры

&НаКлиенте
Процедура ВодительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ВодительЗаписан = Ложь;	
	Для Каждого ИнформацияВодителя Из Элемент.СписокВыбора Цикл
		Если ИнформацияВодителя.Значение.Водитель = Текст Тогда 
			ВодительЗаписан = Истина
		КонецЕсли;
	КонецЦикла;
	Если Не ВодительЗаписан Тогда
		Объект.УдостоверениеНомер = "";
		Объект.УдостоверениеСерия  = "";
		Объект.Водитель			  = Текст;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильГосударственныйНомерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбранноеЗначение.Свойство("АвтомобильМарка",							Объект.АвтомобильМарка);
	ВыбранноеЗначение.Свойство("АвтомобильГосударственныйНомер",			Объект.АвтомобильГосударственныйНомер);
	ВыбранноеЗначение.Свойство("ЛицензионнаяКарточкаВид",					Объект.ЛицензионнаяКарточкаВид);
	ВыбранноеЗначение.Свойство("ЛицензионнаяКарточкаНомер",					Объект.ЛицензионнаяКарточкаНомер);
	ВыбранноеЗначение.Свойство("ЛицензионнаяКарточкаРегистрационныйНомер",	Объект.ЛицензионнаяКарточкаРегистрационныйНомер);
	ВыбранноеЗначение.Свойство("ЛицензионнаяКарточкаСерия",					Объект.ЛицензионнаяКарточкаСерия);
	ВыбранноеЗначение.Свойство("Прицеп",									Объект.Прицеп);
	ВыбранноеЗначение.Свойство("ГосударственныйНомерПрицепа",				Объект.ГосударственныйНомерПрицепа);
	ВыбранноеЗначение.Свойство("ВидПеревозки",								Объект.ВидПеревозки);
	ВыбранноеЗначение.Свойство("АвтомобильВместимостьВКубическихМетрах",	Объект.АвтомобильВместимостьВКубическихМетрах);
	ВыбранноеЗначение.Свойство("АвтомобильГрузоподъемностьВТоннах",			Объект.АвтомобильГрузоподъемностьВТоннах);
	ВыбранноеЗначение.Свойство("АвтомобильТип",								Объект.АвтомобильТип);
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ГрузоотправительПриИзмененииНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура ГрузоотправительПриИзмененииНаСервере()
	
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораФИОВодителей(Элементы.Водитель, Объект.Грузоотправитель);
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораТранспортныхСредств(Элементы.АвтомобильГосударственныйНомер, Объект.Грузоотправитель);
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораТиповТранспортныхСредств(Элементы.АвтомобильТип, Объект.Грузоотправитель);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресПогрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
	    Элемент,
		Объект,
		"АдресПогрузки",
		СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресПогрузкиПриИзменении(Элемент)
		
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект.АдресПогрузки,
		Объект.АдресПогрузкиЗначенияПолей);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресПогрузкиОчистка(Элемент, СтандартнаяОбработка)
	 АдресПогрузкиПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АдресПогрузкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	АдресПогрузкиПриИзменении(Элемент);	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
		Элемент,
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
	    Элемент,
		Объект,
		"АдресДоставки",
		СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОчистка(Элемент, СтандартнаяОбработка)
	АдресДоставкиПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	АдресДоставкиПриИзменении(Элемент);	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказчикПеревозкиПриИзменении(Элемент)
			
	УстановитьБанковскийСчетЗаказчикаПеревозки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(Элемент)
		
	УстановитьБанковскийСчетПлательщика();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	УстановитьБанковскийСчетПеревозчика();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильТипОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбранноеЗначение.Свойство("АвтомобильВместимостьВКубическихМетрах",	Объект.АвтомобильВместимостьВКубическихМетрах);
	ВыбранноеЗначение.Свойство("АвтомобильГрузоподъемностьВТоннах",			Объект.АвтомобильГрузоподъемностьВТоннах);
	ВыбранноеЗначение.Свойство("АвтомобильТип",								Объект.АвтомобильТип);
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильТипОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ТранспортноеСредствоЗаписано = Ложь;	
	Для Каждого ИнформацияТранспорногоСредства Из Элемент.СписокВыбора Цикл
		Если ИнформацияТранспорногоСредства.Значение.АвтомобильТип = Текст Тогда 
			ТранспортноеСредствоЗаписано = Истина
		КонецЕсли;
	КонецЦикла;
	Если Не ТранспортноеСредствоЗаписано Тогда
		Объект.АвтомобильГрузоподъемностьВТоннах  		= "";
		Объект.АвтомобильВместимостьВКубическихМетрах  	= "";
		Объект.АвтомобильТип							= Текст;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОснованияПослеУдаления(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОснованияДокументОснованиеПриИзменении(Элемент)
		
	Если Элемент.Родитель.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.ДокументыОснования.НайтиПоИдентификатору(Элементы.ДокументыОснования.ТекущаяСтрока); 
	
	НайденныеСтроки = Объект.ДокументыОснования.НайтиСтроки(Новый Структура("ДокументОснование", ТекущаяСтрока.ДокументОснование));
	
	Если НайденныеСтроки.Количество() > 1 Тогда
		
		Объект.ДокументыОснования.Удалить(НайденныеСтроки[1]);
		Элементы.ДокументыОснования.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыОснования

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
		
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораФИОВодителей(Элементы.Водитель, Объект.Грузоотправитель);
	
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораТранспортныхСредств(Элементы.АвтомобильГосударственныйНомер, Объект.Грузоотправитель);
		
	Документы.ТранспортнаяНакладная.УстановитьСписокВыбораТиповТранспортныхСредств(Элементы.АвтомобильТип, Объект.Грузоотправитель);
	
	Элементы.ЗаданиеНаПеревозку.Видимость = ЗначениеЗаполнено(Объект.ЗаданиеНаПеревозку);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ВыводитьТолькоНомераНакладных = Истина;
	
	Если Форма.Объект.ДокументыОснования.Количество() = 1 Тогда 	
		ВыводитьТолькоНомераНакладных = Ложь;	
	КонецЕсли;
		
	Форма.Элементы.ВыводДанныхОТоварномСоставе.Доступность = Не ВыводитьТолькоНомераНакладных;
			
	Если ВыводитьТолькоНомераНакладных Тогда 																
		Форма.Объект.ВыводДанныхОТоварномСоставе = ПредопределенноеЗначение("Перечисление.ВариантыВыводаДанныхОТоварномСоставе.НомераНакладных");
	КонецЕсли;
																							
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
КонецПроцедуры

&НаСервере
Процедура УстановитьБанковскийСчетПлательщика()
	
	Если Не ЗначениеЗаполнено(Объект.БанковскийСчетПлательщика) Тогда	
		Если ЗначениеЗаполнено(Объект.Плательщик) Тогда
			Если  ТипЗнч(Объект.Плательщик) = Тип("СправочникСсылка.Контрагенты") Тогда
				Объект.БанковскийСчетПлательщика = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(Объект.Плательщик);
			Иначе
				СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
				СтруктураПараметров.Организация    		= Объект.Плательщик;
				Объект.БанковскийСчетПлательщика = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБанковскийСчетЗаказчикаПеревозки()
	
	Если Не ЗначениеЗаполнено(Объект.БанковскийСчетЗаказчикаПеревозки) Тогда	
		Если ЗначениеЗаполнено(Объект.ЗаказчикПеревозки) Тогда
			Если  ТипЗнч(Объект.ЗаказчикПеревозки) = Тип("СправочникСсылка.Контрагенты") Тогда
				Объект.БанковскийСчетЗаказчикаПеревозки = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(Объект.ЗаказчикПеревозки);
			Иначе
				СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
				СтруктураПараметров.Организация    		= Объект.ЗаказчикПеревозки;
				Объект.БанковскийСчетЗаказчикаПеревозки = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;

КонецПроцедуры	
	
&НаСервере
Процедура УстановитьБанковскийСчетПеревозчика()
	
 	
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
