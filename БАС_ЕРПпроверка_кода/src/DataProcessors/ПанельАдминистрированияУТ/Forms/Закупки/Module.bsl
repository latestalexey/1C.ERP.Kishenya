&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьВерсионированиеОбъектов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСинхронизациюДанных");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыКлиентов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаВнутреннееПотребление");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаСборку");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПередачиТоваровМеждуОрганизациями");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоСкладов");
	ВнешниеРодительскиеКонстанты.Вставить("УчитыватьСебестоимостьТоваровПоВидамЗапасов");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	//++ НЕ УТ
	Элементы.ПояснениеИспользованиеЭтаповОплатыВЗакупках.Заголовок = НСтр("ru='Настройка определяет возможные варианты планирования оплаты в документах ""Заказ поставщику"", ""Отчет комитенту"",
        |""Заказ переработчику"".'
        |;uk='Настройка визначає можливі варіанти планування оплати в документах ""Замовлення постачальнику"", ""Звіт комітенту"",
        |""Замовлення переробнику"".'");
	//-- НЕ УТ
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьЗаказыПоставщикамПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьЗаказыПоставщикам И НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Истина);
		
	Иначе
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Ложь);
		
	КонецЕсли;

	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПоступлениеПоНесколькимЗаказамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыПоставщикамБезПолногоПоступленияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыПоставщикамБезПолнойОплатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАктыОРасхожденияхПослеПриемкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАктыОРасхожденияхПослеОтгрузкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКомиссиюПриЗакупкахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИмпортныеТоварыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИмпортныеЗакупкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКорректировкиПоступленийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЗапретитьПоступлениеТоваровБезНомеровГТДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСогласованиеЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПричиныОтменыЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСкладыВТабличнойЧастиДокументовЗакупкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеЭтаповОплатыВЗакупкахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСоглашенияСПоставщикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоговорыСПоставщикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВерсионированиеДокументовЗакупки(Команда)
	
	Результат = Новый Структура;
	СохранитьЗначениеРеквизита("ВключитьВерсионированиеДокументовЗакупки", Результат);
	
	Если Результат.Свойство("ВерсионированиеВключено") Тогда
		
		Если Результат.ВерсионированиеВключено Тогда
			Пояснение = НСтр("ru='Для документов заказов поставщику установлен вариант версионирования ""Версионировать при проведении""';uk='Для документів замовлень постачальнику встановлений варіант версіонування ""Версіонувати при проведенні""'");
		Иначе
			Пояснение = НСтр("ru='Для документов заказов поставщику версионирование уже было включено';uk='Для документів замовлень постачальнику версіонування вже було включено'");
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru='Версионирование включено';uk='Версіонування включено'"),, Пояснение, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеЛогистическихУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийЛогистическиеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеФинансовыхУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийФинансовыеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеЦеновыхУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийЦеновыеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеКоммерческихУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийКоммерческиеУсловияЗакупок")));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ВключитьВерсионированиеДокументовЗакупки" Тогда
			НаборКонстант.ИспользоватьВерсионированиеОбъектов = Истина;
			КонстантаИмя = "ИспользоватьВерсионированиеОбъектов";
		КонецЕсли;

	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ВключитьВерсионированиеДокументовЗакупки" Тогда
		
		ОбъектыДляВерсионирования = Новый Соответствие;
		
		Если НаборКонстант.ИспользоватьЗаказыПоставщикам Тогда
			ОбъектыДляВерсионирования.Вставить("Документ.ЗаказПоставщику", "ВерсионироватьПриПроведении");
		КонецЕсли;
		
		Результат.Вставить("ВерсионированиеВключено",
			ОбщегоНазначенияУТ.ВключитьВерсионированиеОбъектов(ОбъектыДляВерсионирования));
		
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыПоставщикам;
		ЕстьОбменыСФормированиемДоговоровПоЗаказам =
			Константы.ИспользоватьСинхронизациюДанных.Получить() И ОбменДаннымиУТУП.ЕстьОбменыСФормированиемДоговоровПоЗаказам();
		
		Элементы.ИспользоватьПоступлениеПоНесколькимЗаказам.Доступность 				= ЗначениеКонстанты И НЕ ЕстьОбменыСФормированиемДоговоровПоЗаказам;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления.Доступность 			= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты.Доступность				= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.ИспользоватьСогласованиеЗаказовПоставщикам.Доступность 				= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.ГруппаКомментарийИспользоватьПоступлениеПоНесколькимЗаказам.Видимость 	= ЕстьОбменыСФормированиемДоговоровПоЗаказам;
		Элементы.ИспользоватьСтатусыЗаказовПоставщикам.Доступность                      = ЗначениеКонстанты;
		Элементы.ИспользоватьПричиныОтменыЗаказовПоставщикам.Доступность                = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийКонтролироватьЗакрытие.Видимость                      = ЗначениеКонстанты И НЕ НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам;
		
		Элементы.НазначитьОтветственныхЗаСогласованиеЛогистическихУсловийДокументовЗакупки.Доступность = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеФинансовыхУсловийДокументовЗакупки.Доступность    = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеЦеновыхУсловийДокументовЗакупки.Доступность       = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеКоммерческихУсловийДокументовЗакупки.Доступность  = ЗначениеКонстанты;
		
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		
		Элементы.ИспользоватьСогласованиеЗаказовПоставщикам.Доступность        = НаборКонстант.ИспользоватьЗаказыПоставщикам И ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления.Доступность = ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты.Доступность       = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийКонтролироватьЗакрытие.Видимость             = НаборКонстант.ИспользоватьЗаказыПоставщикам И НЕ ЗначениеКонстанты;
			
		УстановитьДоступностьВерсионированияДокументовЗакупки();
		
	КонецЕсли;
	
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИмпортныеТовары" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИмпортныеТовары;
		
		Элементы.ИспользоватьИмпортныеЗакупки.Доступность = ЗначениеКонстанты;
		Элементы.ЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТД.Доступность = ЗначениеКонстанты;
		Элементы.ЗапретитьПоступлениеТоваровБезНомеровГТД.Доступность       = ЗначениеКонстанты;
		Элементы.КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениям.Доступность  = НаборКонстант.ИспользоватьИмпортныеЗакупки;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИмпортныеЗакупки" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИмпортныеЗакупки;
		
		Элементы.КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениям.Доступность  = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВерсионированиеОбъектов" ИЛИ РеквизитПутьКДанным = "" Тогда
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоСкладов;
		
		Элементы.ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки.Доступность = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийИспользоватьСкладыВТабличнойЧастиДокументовЗакупки.Видимость = Не ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = Константы.ИспользоватьПродажуАгентскихУслуг.Получить();
		Элементы.ИспользоватьКомиссиюПриЗакупках.Доступность = НЕ ЗначениеКонстанты;
		Элементы.ГруппаКомментарийИспользоватьКомиссионныеЗакупки.Видимость = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов;
		Элементы.ИспользоватьКомиссиюПриЗакупках.Доступность = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийИспользоватьКомиссионныеЗакупкиВидыЗапасов.Видимость = НЕ ЗначениеКонстанты;
	КонецЕсли;
	
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
	ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным);
	
	Если НЕ Константы.ИспользоватьНЕУКРОбъекты.Получить() Тогда
		Элементы.ИспользоватьКорректировкиПоступлений.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным)
	
	СтруктураКонстант = Новый Структура(
		"ИспользоватьСтатусыЗаказовПоставщикам,
		|ИспользоватьКомиссиюПриЗакупках,
		|КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениям,
		|ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки,
		|ИспользоватьИмпортныеТовары");
	
	Для Каждого КлючИЗначение Из СтруктураКонстант Цикл
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы[КлючИЗначение.Ключ],
			НаборКонстант[КлючИЗначение.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаСервере
Процедура УстановитьДоступностьВерсионированияДокументовЗакупки()
	
	Элементы.ВключитьВерсионированиеДокументовЗакупки.Доступность =
		НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам
		И (НЕ НаборКонстант.ИспользоватьВерсионированиеОбъектов
			ИЛИ НЕ ОбщегоНазначенияУТ.ИспользоватьВерсионированиеОбъекта("Документ.ЗаказПоставщику"));
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Использование)
	
	Константы.ИспользоватьЗаказыПоставщикамИЗаявкиНаРасходованиеДС.Установить(Использование);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
