&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы.
	СоставНабораКонстантФормы    = ПолучитьСтруктуруНабораКонстантЭД(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ПолучитьСтруктуруРодительскихКонстантЭД(СоставНабораКонстантФормы);
	РежимРаботы                  = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЭлектронныеПодписи");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия"               , 
						ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаИспользоватьЭлектронныеПодписи.Видимость        = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаИспользоватьОбменЭДМеждуОрганизациями.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	
	Если ЕстьОбменСКонтрагентами Тогда
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Элементы.ГруппаНастройкиРегламентногоЗадания.Видимость = Ложь;
		Иначе
			УстановитьНастройкиЗаданий();
		КонецЕсли;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	Элементы.ГруппаНастройкиОбменаСКонтрагентами.Видимость = ЕстьОбменСКонтрагентами;
	
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
			И ПолучитьОбщиеКлючиСтруктурЭД(Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтотОбъект.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОбменЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныеПодписиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменЭДМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьНемедленнуюОтправкуЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНастройкиПрофилейЭДО(Команда)
	
	ФормаСписка = "Справочник.ПрофилиНастроекЭДО.Форма.ФормаСписка";
	ОткрытьФорму(ФормаСписка, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоглашенияОбИспользованииЭД(Команда)
	
	ФормаСписка = "Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаСписка";
	ОткрытьФорму(ФормаСписка, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПорталу1СЭДО(Команда)
	
	МодульОбработки = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиКлиент");
	МодульОбработки.ПомощникПодключенияКСервису1СЭДО();
	
КонецПроцедуры

// СтандартныеПодсистемы.ЭлектроннаяПодпись
&НаКлиенте
Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

&НаКлиенте
Процедура НастроитьОтправкуЭД(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОтправкиЭД", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОтправкиЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПолучениеЭД(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеПолученияЭД", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеПолученияЭД);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

// Константы

&НаКлиенте
// Возвращает структуру, содержащую ключи, имеющиеся в обеих исходных структурах.
//
Функция ПолучитьОбщиеКлючиСтруктурЭД(Структура1, Структура2)
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстантыЭД(КонстантаИмя, КонстантаЗначение) Тогда
			УстановитьЗначенияЗависимыхКонстант(КонстантаИмя);
			ЭтотОбъект.Прочитать();
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура(
			"ИмяСобытия, Параметр, Источник",
			"Запись_НаборКонстант", ПолучитьСтруктуруПодчиненныхКонстантЭД(КонстантаИмя), КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьЭлектронныеПодписи = Константы.ИспользоватьЭлектронныеПодписи.Получить();
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	
	Если ЕстьОбменСКонтрагентами
		И (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменЭД" ИЛИ РеквизитПутьКДанным = "") Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьОбменЭД;
		ВключеныЭДиЭП    = ЗначениеКонстанты И ИспользоватьЭлектронныеПодписи;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьТиповыеСоглашенияОбИспользованииЭД", "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьСоглашенияОбИспользованииЭД", "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьПомощникПодключенияКПрямомуОбмену", "Доступность", ЗначениеКонстанты);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьОбменЭДМеждуОрганизациями", "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьПомощникПодключенияКСервису1СЭДО", "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ОткрытьАрхивЭДО", "Доступность", ЗначениеКонстанты);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьАвтоматическуюОтправкуЭД", "Доступность", ЕстьОбменСКонтрагентами);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьАвтоматическоеПолучениеЭД", "Доступность", ЕстьОбменСКонтрагентами);
			
		ДоступноАдминистрирование = Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаНастройкиРегламентногоЗадания", "Доступность", ЗначениеКонстанты И ДоступноАдминистрирование);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ИспользоватьЭлектронныеПодписи", "Доступность", ЭтоПолноправныйПользователь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "НастройкиЭлектроннойПодписиИШифрования", "Доступность", ИспользоватьЭлектронныеПодписи);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Константы

&НаСервере
Процедура УстановитьЗначенияЗависимыхКонстант(ИмяРодительскойКонстанты)
	
	СтруктуруПодчиненныхКонстант = ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты);
	Для Каждого ИмяКонстанты Из СтруктуруПодчиненныхКонстант Цикл
		Константы[ИмяКонстанты.Ключ].Установить(НаборКонстант[ИмяРодительскойКонстанты]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
// Возвращает состав набор констант.
//
// Параметры:
//	Набор - КонстантыНабор.
//
// Возвращаемое значение:
//  Структура
//		Ключ - имя константы из набора.
//
Функция ПолучитьСтруктуруНабораКонстантЭД(Набор)
	
	Результат = Новый Структура;
	
	Для Каждого МетаКонстанта Из Метаданные.Константы Цикл
		Если ЕстьРеквизитОбъекта(Набор, МетаКонстанта.Имя) Тогда
			Результат.Вставить(МетаКонстанта.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита)
	
	КлючУникальностиЭД   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальностиЭД);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальностиЭД;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "подчиненные" константы для указанной "родительской" константы.
//
//	Параметры:
//		ИмяРодительскойКонстанты - Структура - имя родительской константы
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя подчиненной константы
//
Функция ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура("ИмяРодительскойКонстанты", ИмяРодительскойКонстанты));
	
	Для Каждого СтрокаПодчиненного Из ПодчиненныеКонстанты Цикл
		
		Если Результат.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		ПодчиненныеПодчиненных = ПолучитьСтруктуруПодчиненныхКонстантЭД(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		Для Каждого ПодчиненныйПодчиненного Из ПодчиненныеПодчиненных Цикл
			Результат.Вставить(ПодчиненныйПодчиненного.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "родительские" константы для указанных "подчиненных" констант.
//
//	Параметры:
//		СтруктураПодчиненныхКонстант - Структура - имена подчиненных констант
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя родительской константы
//
Функция ПолучитьСтруктуруРодительскихКонстантЭД(СтруктураПодчиненныхКонстант)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстантЭД(Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает таблицу, описывающую зависимость констант в конфигурации.
// Каждая строка таблицы означает:
// для родительской константы со значением Х допустимо только значение Y для подчиненной константы.
//
// Возвращаемое значение:
//	ТаблицаЗначений с колонками
//		- ИмяРодительскойКонстанты
//		- ИмяПодчиненнойКонстанты
//		- ЗначениеРодительскойКонстанты
//		- ЗначениеПодчиненнойКонстанты
//
Функция ПолучитьТаблицуЗависимостиКонстантЭД()
	
	Результат = Новый ТаблицаЗначений;
	
	Результат.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗначениеРодительскойКонстанты");
	Результат.Колонки.Добавить("ЗначениеПодчиненнойКонстанты");
	
	Результат.Индексы.Добавить("ИмяРодительскойКонстанты");
	Результат.Индексы.Добавить("ИмяПодчиненнойКонстанты");
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");

	Если ЕстьОбменСКонтрагентами Тогда
		
		ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(
			Результат, "ИспользоватьОбменЭД", Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", Ложь);
	
		ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(
			Результат, "ИспользоватьЭлектронныеПодписи", Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", Ложь);
			
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(ТаблицаКонстант,
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты, ИмяПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты)
	
	НоваяСтрока = ТаблицаКонстант.Добавить();
	НоваяСтрока.ИмяРодительскойКонстанты      = ИмяРодительскойКонстанты;
	НоваяСтрока.ЗначениеРодительскойКонстанты = ЗначениеРодительскойКонстанты;
	НоваяСтрока.ИмяПодчиненнойКонстанты       = ИмяПодчиненнойКонстанты;
	НоваяСтрока.ЗначениеПодчиненнойКонстанты  = ЗначениеПодчиненнойКонстанты;
	
КонецПроцедуры

&НаСервере
// Возвращает признак наличия у константы "подчиненных" констант.
//
//	Параметры:
//		ИмяРодительскойКонстанты 	  - Строка - имя константы как оно задано в конфигураторе
//		ЗначениеРодительскойКонстанты - Произвольный - значение константы
//
//	Возвращаемое значение:
//		Булево - если Истина, то у константы есть "подчиненные" ей константы.
//
Функция ЕстьПодчиненныеКонстантыЭД(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты)
	
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	РегЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания[ИмяЗадания]);
	РегЗадание.Использование = Использование;
	РегЗадание.Записать();
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент)
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	РегЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания[ИмяЗадания]);
	РегЗадание.Расписание = РасписаниеРегламентногоЗадания;
	РегЗадание.Записать();
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОтправкиЭД(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОтправкиЭД = РасписаниеЗадания;

	ИзменитьРасписаниеЗадания("ОтправкаОформленныхЭД", РасписаниеЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеПолученияЭД(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеПолученияЭД = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("ПолучениеНовыхЭД", РасписаниеЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическоеПолучениеЭДПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("ПолучениеНовыхЭД", ИспользоватьАвтоматическоеПолучениеЭД);
	
	Элементы.ПолучениеНовыхЭД.Доступность = ИспользоватьАвтоматическоеПолучениеЭД;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическуюОтправкуЭДПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("ОтправкаОформленныхЭД", ИспользоватьАвтоматическуюОтправкуЭД);
	
	Элементы.ОтправкаОформленныхЭД.Доступность = ИспользоватьАвтоматическуюОтправкуЭД;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно) Экспорт
	
	РасписаниеАктивно = Ложь;
	
	ТекстЗаголовка = "Дополнительные настройки расписания ...";
	
	Если Задание = Неопределено Тогда
		
		//ТекстЗаголовка = "Создать регламентную настройку ...";
		ТекстРасписания = "<Расписание не задано>";
		
	Иначе
		
		//ТекстЗаголовка = "Дополнительные настройки расписания ...";
		Если Задание.Использование Тогда
			ПрефиксРасписания = "Расписание: ";
			РасписаниеАктивно = Истина;
		Иначе
			ПрефиксРасписания = "Расписание (НЕ АКТИВНО): ";
		КонецЕсли;
		
		ТекстРасписания = ПрефиксРасписания + Строка(Задание.Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Устанавливаем флаг "ИспользоватьАвтоматическуюОтправкуЭД"
	ЗаданиеОтправкаЭД = РегламентныеЗадания.НайтиПредопределенное(
		Метаданные.РегламентныеЗадания.Найти("ОтправкаОформленныхЭД"));
	ИспользоватьАвтоматическуюОтправкуЭД = ЗаданиеОтправкаЭД.Использование;
	РасписаниеОтправкиЭД = ЗаданиеОтправкаЭД.Расписание;
	Элементы.ОтправкаОформленныхЭД.Доступность = ИспользоватьАвтоматическуюОтправкуЭД;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОтправкаЭД, Элементы.ОтправкаОформленныхЭД);
	
	// Устанавливаем флаг "ИспользоватьАвтоматическоеПолучениеЭД"
	ЗаданиеПолучениеЭД = РегламентныеЗадания.НайтиПредопределенное(
		Метаданные.РегламентныеЗадания.Найти("ПолучениеНовыхЭД"));
	ИспользоватьАвтоматическоеПолучениеЭД = ЗаданиеПолучениеЭД.Использование;
	РасписаниеПолученияЭД = ЗаданиеПолучениеЭД.Расписание;
	Элементы.ПолучениеНовыхЭД.Доступность = ИспользоватьАвтоматическоеПолучениеЭД;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеПолучениеЭД, Элементы.ПолучениеНовыхЭД);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно;
	
	ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

#КонецОбласти