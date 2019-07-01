
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	МассивТипов = Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОбластьДействия,
		"СертификатНоменклатуры",
		Справочники.СертификатыНоменклатуры.ПустаяСсылка(),
		ВидСравненияКомпоновкиДанных.Равно);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"ВидНоменклатуры",
		ВидНоменклатурыОтбор,
		ЗначениеЗаполнено(ВидНоменклатурыОтбор));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		НоменклатураОтбор,
		ЗначениеЗаполнено(НоменклатураОтбор) ИЛИ ЗначениеЗаполнено(ВидНоменклатурыОтбор));
				
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СертификатНоменклатуры" Тогда
		
		МассивТипов = СформироватьСписокВыбораТиповСертификатов();
		Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
		Элементы.СертификатыНоменклатуры.Обновить();
		Элементы.ОбластьДействия.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСертификатаПриИзменении(Элемент)
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СертификатыНоменклатуры,
		"ТипСертификата",
		ТипСертификата,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ТипСертификата));
			
КонецПроцедуры

&НаКлиенте
Процедура ТипСертификатаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	МассивТипов = СформироватьСписокТипов(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(МассивТипов);

КонецПроцедуры

&НаКлиенте
Процедура ТолькоДействующиеНаДатуПриИзменении(Элемент)
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	УстановитьОтборПоТолькоДействубщимНаДату();	
		
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОтборПоТолькоДействубщимНаДату();
	
КонецПроцедуры
	
&НаКлиенте
Процедура НоменклатураОтборПриИзменении(Элемент)
	
	УстановитьОтборыПриИзмененииНоменклатуры();	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыОтборПриИзменении(Элемент)
		
	Если ЗначениеЗаполнено(НоменклатураОтбор) Тогда
		Если ВидНоменклатурыОтбор<>ВидНоменклатуры(НоменклатураОтбор) Тогда
			НоменклатураОтбор = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");	
		КонецЕсли;	
	КонецЕсли;
	
	УстановитьОтборыПриИзмененииНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыНоменклатуры

&НаКлиенте
Процедура СертификатыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СертификатыНоменклатурыАктивизацияСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыАктивизацияСтроки()
		
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОбластьДействия, "СертификатНоменклатуры", ТекущаяСтрока.Ссылка, ВидСравненияКомпоновкиДанных.Равно);		
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОбластьДействия,
			"СертификатНоменклатуры",
			ПредопределенноеЗначение("Справочник.СертификатыНоменклатуры.ПустаяСсылка"),
			ВидСравненияКомпоновкиДанных.Равно);	
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура();
	Если Копирование Тогда
		Если Элементы.СертификатыНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		ИначеЕсли Элементы.СертификатыНоменклатуры.ТекущиеДанные.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.СертификатыНоменклатуры.ТекущиеДанные.Ссылка); 	
	Иначе		
		ПараметрыФормы.Вставить("Номенклатура", НоменклатураОтбор);
		ПараметрыФормы.Вставить("ТипСертификата", ТипСертификата);
		ПараметрыФормы.Вставить("ВидНоменклатуры", ВидНоменклатурыОтбор);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьИзображение(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтркутураВозврата = ОткрытьИзображениеНаСервере(ТекущаяСтрока.Ссылка);	

	Если СтркутураВозврата.Результат = "НетИзображений" Тогда
		ТекстСообщения = НСтр("ru='Для сертификата номенклатуры ""%Сертификат%"" отсутствует изображение для просмотра';uk='Для сертифіката номенклатури ""%Сертификат%"" відсутнє зображення для перегляду'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Сертификат%",ТекущаяСтрока.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);	
	ИначеЕсли СтркутураВозврата.Результат = "ОдноИзображение" Тогда
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(
			ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(
			СтркутураВозврата.ПрисоединенныйФайл,
			УникальныйИдентификатор));
	Иначе
		ПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора",
										   ТекущаяСтрока.Ссылка, Истина, Истина);
		ЗначениеВыбора = Неопределено;

		ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы", ПараметрыВыбора,,,,, Новый ОписаниеОповещения("ОткрытьИзображениеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ЗначениеВыбора = Результат;
    
    Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
        
        ПрисоединенныеФайлыКлиент.ОткрытьФайл(
        ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(
        ЗначениеВыбора,
        УникальныйИдентификатор));
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСИстекающимиСертификатами(Команда)
	 
	Форма = ПолучитьФорму("Отчет.ТоварыСИстекающимиСертификатами.Форма");
	
	КомпоновщикНастроекКомпоновкиДанных = Форма.Отчет.КомпоновщикНастроек;
	ПользовательскиеНастройки = КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки;
	
	Если ЗначениеЗаполнено(ВидНоменклатурыОтбор) Тогда
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(ВидНоменклатурыОтбор);

		УстановитьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных,
			ПользовательскиеНастройки,
			"ВидНоменклатуры",
			СписокЗначений,
			ВидСравненияКомпоновкиДанных.ВСписке);
	Иначе
		ОчиститьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, ПользовательскиеНастройки, "ВидНоменклатуры");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоменклатураОтбор) Тогда
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(НоменклатураОтбор);
		
		УстановитьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, 
			ПользовательскиеНастройки,
			"Номенклатура",
			СписокЗначений,
			ВидСравненияКомпоновкиДанных.ВСписке);
	Иначе
		ОчиститьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, ПользовательскиеНастройки, "Номенклатура");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипСертификата) Тогда
		УстановитьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных,
			ПользовательскиеНастройки,
			"ПользовательскиеПоля.Поле1",
			ТипСертификата,
			ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		ОчиститьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных,
			ПользовательскиеНастройки,
			"ПользовательскиеПоля.Поле1");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Дата) И ТолькоДействующиеНаДату Тогда
		Параметр = Новый Структура();
		Параметр.Вставить("Значение", Дата);
		Параметр.Вставить("Использование", Истина);
		УстановитьПараметрПользовательскойНастройки(ПользовательскиеНастройки, "НедействительныеНаДату", Параметр);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СформироватьПриОткрытии, ПользовательскиеНастройки",Истина,ПользовательскиеНастройки);
	Форма = ПолучитьФорму("Отчет.ТоварыСИстекающимиСертификатами.Форма", ПараметрыФормы);	
	ОткрытьФорму(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияНоменклатура.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<для всей номенклатуры>';uk='<для всієї номенклатури>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияХарактеристика.Имя);

	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьХарактеристики");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<для всех характеристик>';uk='<для всіх характеристик>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияСерия.Имя);

	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Серия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьСерии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<для всех серий>';uk='<для всіх серій>'"));
	
	//	
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ОбластьДействияХарактеристика",
																		     "ОбластьДействия.ИспользоватьХарактеристики");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияСерия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьСерии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<серия не указывается>';uk='<серія не зазначається>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыДатаОкончанияСрокаДействия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Бессрочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<бессрочный>';uk='<безстроковий>'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоТолькоДействубщимНаДату()
	                              
	ГруппаОтборПоДействующимНаДату = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(СертификатыНоменклатуры).Элементы,
		"ГруппаОтборПоДействующимНаДату",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДействующимНаДату, "Статус", ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Действующий"), 
		ВидСравненияКомпоновкиДанных.Равно, "ГруппаОтборПоДействующимНаДату", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ГруппаОтборПоДате = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ГруппаОтборПоДействующимНаДату,
		"ГруппаОтборПоДате",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);	
		
    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "ДатаОкончанияСрокаДействия", Дата, 
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно, "ОтборПоДате", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "Бессрочный", Истина, 
		ВидСравненияКомпоновкиДанных.Равно, "ОтборПоДатеБессрочный", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
	
КонецПроцедуры

&НаСервере
Функция ВидНоменклатуры(Номенклатура)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ВидНоменклатуры");
		
КонецФункции

&НаСервере
Функция ОткрытьИзображениеНаСервере(СертификатНоменкалтуры);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК ПрисоединенныйФайл,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК КоличествоФайлов,
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла
	|ИЗ
	|	Справочник.СертификатыНоменклатурыПрисоединенныеФайлы КАК СертификатыНоменклатурыПрисоединенныеФайлы
	|ГДЕ
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И СертификатыНоменклатурыПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", СертификатНоменкалтуры);
	
	Выборка = Запрос.Выполнить().Выбрать();	

	СтруктураВозврата = Новый Структура;
	
	Если Выборка.Следующий() Тогда
		Если Выборка.КоличествоФайлов > 1 Тогда
			СтруктураВозврата.Вставить("Результат", "МассивИзображений");
		ИначеЕсли Выборка.КоличествоФайлов = 1 Тогда
			СтруктураВозврата.Вставить("Результат", "ОдноИзображение");
			СтруктураВозврата.Вставить("ПрисоединенныйФайл", Выборка.ПрисоединенныйФайл);
		КонецЕсли;				
	Иначе
		СтруктураВозврата.Вставить("Результат", "НетИзображений");
	КонецЕсли;	
			
	Возврат СтруктураВозврата;
	
КонецФункции	

&НаКлиенте
Процедура УстановитьОтборыПриИзмененииНоменклатуры()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		НоменклатураОтбор,
		ЗначениеЗаполнено(НоменклатураОтбор));
		
	Если ЗначениеЗаполнено(НоменклатураОтбор) Тогда
		
		ВидНоменклатурыОтбор = ВидНоменклатуры(НоменклатураОтбор);
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ВидНоменклатуры",
			ВидНоменклатурыОтбор,
			ЗначениеЗаполнено(ВидНоменклатурыОтбор));
			
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ТолькоВидНоменклатуры",
			ВидНоменклатурыОтбор,
			Ложь);
			
		Если Не ЗначениеЗаполнено(ВариантОтображенияТаблицы) Тогда			
			ВариантОтображенияТаблицы = Элементы.СертификатыНоменклатуры.Отображение;
			Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы.Список;		
		КонецЕсли;
		
	Иначе
				
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ТолькоВидНоменклатуры",
			ВидНоменклатурыОтбор,
			ЗначениеЗаполнено(ВидНоменклатурыОтбор));
			
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ВидНоменклатуры",
			ВидНоменклатурыОтбор,
			Ложь);
	
		Если ЗначениеЗаполнено(ВариантОтображенияТаблицы) Тогда
			Если ВариантОтображенияТаблицы = "Иерархический список" Тогда
				Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы.ИерархическийСписок;
			Иначе
				Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы[ВариантОтображенияТаблицы];
			КонецЕсли;	
			ВариантОтображенияТаблицы = Неопределено;
		КонецЕсли;
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, ПользовательскиеНастройки, ИмяНастройки, ЗначениеНастройки, ВидСравнения)
	
	ПолеКомпановки = Новый ПолеКомпоновкиДанных(ИмяНастройки);
	ЭлементОтбора = Неопределено;
	
	Для Каждого Элемент Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = ПолеКомпановки Тогда
			ЭлементОтбора = Элемент;
			Прервать;	
		КонецЕсли;			
	КонецЦикла;
	
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
	
	Элемент.ВидСравнения     = ВидСравнения;
	Элемент.ПравоеЗначение   = ЗначениеНастройки;
	Элемент.Использование    = Истина;
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПараметрПользовательскойНастройки(ПользовательскиеНастройки, ИмяНастройки, Параметр)
	
	ПолеКомпановкиПараметр = Новый ПараметрКомпоновкиДанных(ИмяНастройки);
	ЭлементОтбора = Неопределено;
	
	Для Каждого Элемент Из ПользовательскиеНастройки.Элементы Цикл
		Если Элемент.Параметр = ПолеКомпановкиПараметр Тогда
			Элемент.Значение = Параметр.Значение;
			Элемент.Использование = Параметр.Использование; 
			Прервать;	
		КонецЕсли;			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, ПользовательскиеНастройки, ИмяНастройки)
	
	ПолеКомпановки = Новый ПолеКомпоновкиДанных(ИмяНастройки);
	ЭлементОтбора = Неопределено;
	
	Для Каждого Элемент Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = ПолеКомпановки Тогда
			ЭлементОтбора = Элемент;
			Прервать;	
		КонецЕсли;			
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
	
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент.Использование    = Ложь
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция СформироватьСписокТипов(Текст)
	
	Возврат Справочники.СертификатыНоменклатуры.АвтоПодборТиповСертификатов(Текст);
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьСписокВыбораТиповСертификатов()
	
	Возврат Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	
КонецФункции

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СертификатыНоменклатуры);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

