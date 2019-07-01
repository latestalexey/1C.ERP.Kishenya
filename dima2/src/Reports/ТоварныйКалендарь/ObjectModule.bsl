#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;

	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.СпрНоменклатура.Запрос;
	
	ИсточникУпаковки = "СпрНоменклатура.ЕдиницаИзмерения";
	ИсточникНоменклтауры = "СпрНоменклатура.Ссылка";
	Подстановка = Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки(ИсточникУпаковки, ИсточникНоменклтауры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаВесНоменклатуры", Подстановка);
	Подстановка = Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки(ИсточникУпаковки, ИсточникНоменклтауры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаОбъемНоменклатуры", Подстановка);
	СхемаКомпоновкиДанных.НаборыДанных.СпрНоменклатура.Запрос = ТекстЗапроса;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьСтруктуруЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	ЕстьПолеРегистратор = МакетКомпоновки.НаборыДанных.Найти("Регистраторы") <> Неопределено;
	ВнешниеНаборыДанных = ВнешниеНаборыДанных(ЕстьПолеРегистратор);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ДатаОкончания = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОкончания");
	
	Если ДатаОкончания <> Неопределено И ДатаОкончания.Использование Тогда
		Если НачалоДня(ДатаОкончания.Значение) < НачалоДня(ТекущаяДата()) Тогда
			ДатаОкончания.Значение = НачалоДня(ТекущаяДата());
		КонецЕсли;
	КонецЕсли;

	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ПолучитьСтруктуруЗаголовковПолей()
	
	Возврат КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

Функция ВнешниеНаборыДанных(ЕстьПолеРегистратор)
	
	МакетДляОтборов = ПолучитьМакет("ВнешнийИсточникДанных");
	Адрес = ПоместитьВоВременноеХранилище(МакетДляОтборов);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(Адрес);
	
	КомпоновщикНастроекМакета = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекМакета.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроекМакета.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	КомпоновщикНастроекМакета.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	
	// Нужно выбрать все поля, независимо от пользовательских настроек основного отчета.
	Для Каждого Элемент Из КомпоновщикНастроекМакета.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
			ВыбранныеПоля = Элемент.Элементы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ВыбранныеПоля.Очистить();
	Для Каждого ДоступноеПолеВыбора Из КомпоновщикНастроекМакета.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если ЗначениеЗаполнено(ДоступноеПолеВыбора.Тип) Тогда
			ВыбранноеПоле = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Использование = Истина;
			ВыбранноеПоле.Поле = ДоступноеПолеВыбора.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Отбор по сегментам.
	ПараметрИспользуетсяОтборПоСегменту = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек, "ИспользуетсяОтборПоСегментуНоменклатуры");
	ЕстьОтбор = ПараметрИспользуетсяОтборПоСегменту.Значение И ПараметрИспользуетсяОтборПоСегменту.Использование;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроекМакета.Настройки, "ИспользуетсяОтборПоСегментуНоменклатуры", Истина, ЕстьОтбор);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(МакетДляОтборов, КомпоновщикНастроекМакета.ПолучитьНастройки(), , , , Ложь);
	
	УдалитьИзВременногоХранилища(Адрес);
	
	Запрос = КомпоновкаДанныхСервер.ПолучитьЗапросИзМакетаКомпоновки(Макет, "Набор");
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Результат = Запрос.Выполнить();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МИНИМУМ(Таблица.Период) КАК ПериодМинимум,
		|	МАКСИМУМ(Таблица.Период) КАК ПериодМаксимум
		|ИЗ
		|	ВтТоварныйКалендарь КАК Таблица";
	Выборка = Запрос.Выполнить().Выбрать();
	ТаблицаПериодов = Новый ТаблицаЗначений();
	ТаблицаПериодов.Колонки.Добавить("Период", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	Если Выборка.Следующий() И Не Выборка.ПериодМинимум = Null Тогда
		
		ПериодМинимум  = Выборка.ПериодМинимум;
		ПериодМаксимум = Выборка.ПериодМаксимум;
		
		ПараметрДатаОкончания = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОкончания");
		Если ПараметрДатаОкончания = Неопределено Тогда
			ДатаНачала = НачалоДня(ТекущаяДатаСеанса());
		ИначеЕсли ТипЗнч(ПараметрДатаОкончания.Значение) = Тип("СтандартнаяДатаНачала") Тогда
			ДатаНачала = ПараметрДатаОкончания.Значение.Дата;
		ИначеЕсли ТипЗнч(ПараметрДатаОкончания.Значение) = Тип("Дата") Тогда
			ДатаНачала = ПараметрДатаОкончания.Значение;
		Иначе
			ДатаНачала = НачалоДня(ТекущаяДатаСеанса());
		КонецЕсли;
		
		Если ПараметрДатаОкончания.Использование И ПериодМаксимум < ДатаНачала Тогда
			ПериодМаксимум = ДатаНачала;
		КонецЕсли;
		
		Пока ПериодМинимум <= ПериодМаксимум Цикл
			НоваяСтрока = ТаблицаПериодов.Добавить();
			НоваяСтрока.Период = ПериодМинимум;
			ПериодМинимум = ПериодМинимум + 3600 * 24;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТаблицаПериодов.Количество() = 0 Тогда
		ДатаНачальногоОстатка = '00010101';
	Иначе
		ДатаНачальногоОстатка = Новый Граница(ТаблицаПериодов[0].Период, ВидГраницы.Исключая);
	КонецЕсли;
	
	Запрос.Текст = Макет.НаборыДанных["НаборНачальныеОстатки"].Запрос;
	Запрос.УстановитьПараметр("ДатаНачальногоОстатка", ДатаНачальногоОстатка);
	Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("ТаблицаПериодов", ТаблицаПериодов);
	
	Таблица = ВыгрузитьТаблицуДляРасчетаОстатков(Запрос);
	Запрос.МенеджерВременныхТаблиц.Закрыть();
	
	ДобавитьИЗаполнитьКолонкиНачальныйИКонченыйОстаток(Таблица);
	
	Если ЕстьПолеРегистратор Тогда
		
		Запрос = КомпоновкаДанныхСервер.ПолучитьЗапросИзМакетаКомпоновки(Макет, "НаборСРегистратором");
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
		Результат = Запрос.Выполнить();
		Запрос.УстановитьПараметр("ТаблицаОстатков", Таблица);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура      КАК Номенклатура,
			|	Таблица.Характеристика    КАК Характеристика,
			|	Таблица.Склад             КАК Склад,
			|	Таблица.Период            КАК Период,
			|	
			|	Таблица.ВНаличии          КАК ВНаличии,
			|	Таблица.НачальныйОстаток  КАК НачальныйОстаток,
			|	Таблица.КонечныйОстаток   КАК КонечныйОстаток
			|ПОМЕСТИТЬ ВтОстаткиПоДням
			|ИЗ
			|	&ТаблицаОстатков КАК Таблица
			|ГДЕ
			|	НЕ Таблица.ЭтоПросроченныйПриходИлиРасход
			|;
			|
			|/////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Номенклатура        КАК Номенклатура,
			|	Товары.Характеристика      КАК Характеристика,
			|	Товары.Склад               КАК Склад,
			|	Товары.Период              КАК Период,
			|	Товары.НачальныйОстаток    КАК НачальныйОстаток,
			|	Товары.КонечныйОСтаток     КАК КонечныйОСтаток,
			|	ВЫБОР КОГДА ЕСТЬNULL(Таблица.ПросроченныйПриход, 0) <> 0 ИЛИ ЕСТЬNULL(Таблица.ПросроченныйРасход, 0) <> 0 ТОГДА
			|				ИСТИНА
			|			ИНАЧЕ
			|				ЛОЖЬ
			|		КОНЕЦ                               КАК ЭтоПросроченныйПриходИлиРасход,
			|	
			|	Товары.ВНаличии                         КАК ВНаличии,
			|	ЕСТЬNULL(Таблица.Регистратор, NULL)     КАК Документ,
			|	ЕСТЬNULL(Таблица.КоличествоПриход, 0)   КАК КоличествоПриход,
			|	ЕСТЬNULL(Таблица.КоличествоРасход, 0)   КАК КоличествоРасход,
			|	ЕСТЬNULL(Таблица.ПросроченныйПриход, 0) КАК ПросроченныйПриход,
			|	ЕСТЬNULL(Таблица.ПросроченныйРасход, 0) КАК ПросроченныйРасход
			|ИЗ
			|	ВтОстаткиПоДням КАК Товары
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВтТоварныйКалендарь КАК Таблица
			|		ПО Таблица.Номенклатура   = Товары.Номенклатура
			|		 И Таблица.Характеристика = Товары.Характеристика
			|		 И Таблица.Склад          = Товары.Склад
			|		 И Таблица.Период         = Товары.Период
			|;
			|
			|////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЕСТЬNULL(Таблица.Регистратор, NULL) КАК Регистратор
			|ИЗ
			|	ВтОстаткиПоДням КАК Товары
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВтТоварныйКалендарь КАК Таблица
			|		ПО Таблица.Номенклатура   = Товары.Номенклатура
			|		 И Таблица.Характеристика = Товары.Характеристика
			|		 И Таблица.Склад          = Товары.Склад
			|		 И Таблица.Период         = Товары.Период";
			
		Результат = Запрос.ВыполнитьПакет();
		ОсновнойНабор = Результат[Результат.Количество() - 2].Выгрузить();
		НаборРегистраторы = Результат[Результат.Количество() - 1].Выгрузить();
		ОсновнойНабор.Колонки.Добавить("ПериодСекунда", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
		ВнешниеНаборыДанных = Новый Структура("ОсновнойНабор, НаборРегистраторы", ОсновнойНабор, НаборРегистраторы);
		
	Иначе
		
		ВнешниеНаборыДанных = Новый Структура("ОсновнойНабор", Таблица);
		
	КонецЕсли;
	
	Возврат ВнешниеНаборыДанных;
	
КонецФункции

Процедура ДобавитьИЗаполнитьКолонкиНачальныйИКонченыйОстаток(Таблица)
	
	Таблица.Колонки.Добавить("ЭтоПросроченныйПриходИлиРасход", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("КонечныйОстаток",  ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15, 3));
	Таблица.Колонки.Добавить("Документ",         Новый ОписаниеТипов("ДокументСсылка.ЗаказКлиента"));
	Таблица.Колонки.Добавить("ПериодСекунда",    ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	
	КлючЗаписи = Новый Структура("Номенклатура, Характеристика, Склад");
	Группировки = Новый Массив();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		ИзмениласьЗапись = (КлючЗаписи.Номенклатура <> СтрокаТаблицы.Номенклатура
				Или КлючЗаписи.Характеристика <> СтрокаТаблицы.Характеристика
				Или КлючЗаписи.Склад <> СтрокаТаблицы.Склад);
		
		Если ИзмениласьЗапись Тогда
			КонечныйОстаток = СтрокаТаблицы.НачальныйОстаток + СтрокаТаблицы.ВНаличии;
			ЗаполнитьЗначенияСвойств(КлючЗаписи, СтрокаТаблицы);
			Группировки.Добавить(СтрокаТаблицы);
		КонецЕсли;
		
		СтрокаТаблицы.НачальныйОстаток = КонечныйОстаток;
		КонечныйОстаток = СтрокаТаблицы.НачальныйОстаток + СтрокаТаблицы.КоличествоПриход - СтрокаТаблицы.КоличествоРасход;
		СтрокаТаблицы.КонечныйОстаток = КонечныйОстаток;
		
	КонецЦикла;
	
	Для Каждого Элемент Из Группировки Цикл
		НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент,,"КонечныйОстаток,КоличествоПриход,КоличествоРасход");
		НоваяСтрока.ЭтоПросроченныйПриходИлиРасход = Истина;
		Элемент.ПросроченныйПриход = 0;
		Элемент.ПросроченныйРасход = 0;
	КонецЦикла;
	
КонецПроцедуры

Функция ВыгрузитьТаблицуДляРасчетаОстатков(Запрос)
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Период КАК Период
		|ПОМЕСТИТЬ ВтПериоды
		|ИЗ
		|	&ТаблицаПериодов КАК Таблица
		|;
		|
		|/////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Номенклатура   КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.Склад          КАК Склад
		|ПОМЕСТИТЬ ВтТовары
		|ИЗ
		|	ВтТоварныйКалендарь КАК Таблица
		|;
		|
		|/////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура       КАК Номенклатура,
		|	Товары.Характеристика     КАК Характеристика,
		|	Товары.Склад              КАК Склад,
		|	ТаблицаПериоды.Период     КАК Период,
		|	
		|	ЕСТЬNULL(ТаблицаОстатков.ВНаличии, 0)         КАК ВНаличии,
		|	ЕСТЬNULL(ТаблицаОстатков.НачальныйОстаток, 0) КАК НачальныйОстаток,
		|	ЕСТЬNULL(Таблица.КоличествоПриход, 0)   КАК КоличествоПриход,
		|	ЕСТЬNULL(Таблица.КоличествоРасход, 0)   КАК КоличествоРасход,
		|	ЕСТЬNULL(Таблица.ПросроченныйПриход, 0) КАК ПросроченныйПриход,
		|	ЕСТЬNULL(Таблица.ПросроченныйРасход, 0) КАК ПросроченныйРасход
		|ИЗ
		|	ВтТовары КАК Товары
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПериоды КАК ТаблицаПериоды
		|		ПО ИСТИНА
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтТоварныйКалендарь КАК Таблица
		|		ПО Таблица.Номенклатура   = Товары.Номенклатура
		|		 И Таблица.Характеристика = Товары.Характеристика
		|		 И Таблица.Склад          = Товары.Склад
		|		 И Таблица.Период         = ТаблицаПериоды.Период
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтНачальныеОстатки КАК ТаблицаОстатков
		|		ПО ТаблицаОстатков.Номенклатура   = Товары.Номенклатура
		|		 И ТаблицаОстатков.Характеристика = Товары.Характеристика
		|		 И ТаблицаОстатков.Склад          = Товары.Склад
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика, Склад, Период, ВНаличии УБЫВ";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#КонецЕсли