
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.ПеремещениеНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Документы.ПринятиеКУчетуНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Документы.СписаниеНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
		
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИнвентаризацияНМА) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ИнвентаризацияНМА.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ИнвентаризацияНМА);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
		
	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд отчетов.
//
// Параметры:
// 		КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт



	// НА-4 (Инвентаризационная опись)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НА4";
	КомандаПечати.Представление = НСтр("ru='НА-4 (Инвентаризационная опись)';uk='НА-4 (Інвентаризаційний опис)'");

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НА4") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"НА4",
			НСтр("ru='НА-4 (Инвентаризационная опись)';uk='НА-4 (Інвентаризаційний опис)'"),
		ПечатьНА4(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
		
КонецПроцедуры






Функция ПечатьНА4(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнвентаризацияНМА.Дата КАК Дата,
		|	ИнвентаризацияНМА.Номер КАК Номер,
		|	ИнвентаризацияНМА.Организация КАК Организация,
		|	ИнвентаризацияНМА.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ИнвентаризацияНМА.ПодразделениеОрганизации.Представление КАК ПодразделениеПредставление,
		|	ИнвентаризацияНМА.ПодразделениеОрганизации.Код КАК ПодразделениеКод,
		|	ИнвентаризацияНМА.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
		|	ИнвентаризацияНМА.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
		|	ИнвентаризацияНМА.ДокументОснованиеВид КАК ДокументОснованиеВид,
		|	ИнвентаризацияНМА.ДокументОснованиеДата КАК ДокументОснованиеДата,
		|	ИнвентаризацияНМА.ДокументОснованиеНомер КАК ДокументОснованиеНомер
		|ИЗ
		|	Документ.ИнвентаризацияНМА КАК ИнвентаризацияНМА
		|ГДЕ
		|	ИнвентаризацияНМА.Ссылка = &Ссылка";
		
		Док = Запрос.Выполнить().Выбрать();
		Док.Следующий();
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка.ПолучитьОбъект());
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка",      Ссылка);
		Запрос.УстановитьПараметр("Организация", Док.Организация);
		Запрос.УстановитьПараметр("Дата",        Док.Дата);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнвентаризацияНМАНМА.НомерСтроки КАК НомерСтроки,
		|	ИнвентаризацияНМАНМА.НематериальныйАктив КАК НематериальныйАктив,
		|	ИнвентаризацияНМАНМА.НематериальныйАктив.НаименованиеПолное КАК НематериальныйАктивНаименованиеПолное,
		|	ИнвентаризацияНМАНМА.НаличиеПоДаннымУчета КАК Количество,
		|	ИнвентаризацияНМАНМА.НаличиеФактическое КАК ФактКоличество,
		|	ПервоначальныеСведенияНМА.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
		|	ПервоначальныеСведенияНМА.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
		|	ИнвентаризацияНМАНМА.НакопленнаяАмортизация КАК НакопленнаяАмортизация,
		|	ИнвентаризацияНМАНМА.СтоимостьПоДаннымУчета КАК Стоимость
		|ИЗ
		|	Документ.ИнвентаризацияНМА.НМА КАК ИнвентаризацияНМАНМА
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|					И НематериальныйАктив В
		|						(ВЫБРАТЬ
		|							ИнвентаризацияНМАНМА.НематериальныйАктив
		|						ИЗ
		|							Документ.ИнвентаризацияНМА.НМА КАК ИнвентаризацияНМАНМА
		|						ГДЕ
		|							ИнвентаризацияНМАНМА.Ссылка = &Ссылка)) КАК ПервоначальныеСведенияНМА
		|		ПО ИнвентаризацияНМАНМА.НематериальныйАктив = ПервоначальныеСведенияНМА.НематериальныйАктив
		|ГДЕ
		|	ИнвентаризацияНМАНМА.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		ТаблицаНМА = Запрос.Выполнить().Выгрузить();
		
		Макет = ПолучитьМакет("ПФ_MXL_UK_НА4");
		
		// печать производится на языке, указанном в настройках пользователя
		//КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормироваияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
		КодЯзыкаПечать = "uk";
		//Макет.КодЯзыкаМакета = КодЯзыкаПечать;
		Макет.КодЯзыкаМакета = "ru";
		
		// Получаем области макета для вывода в табличный документ
		Шапка 				= Макет.ПолучитьОбласть("Шапка");
		ЗаголовокТаблицы 	= Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		СтрокаТаблицы 		= Макет.ПолучитьОбласть("СтрокаТаблицы");
		Подвал 				= Макет.ПолучитьОбласть("Подвал");
		Расписка			= Макет.ПолучитьОбласть("Расписка");
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка.ПолучитьОбъект());
		
		
		ТабДокумент = Новый ТабличныйДокумент;
		
		// Зададим параметры макета по умолчанию
		ТабДокумент.ПолеСверху              = 10;
		ТабДокумент.ПолеСлева               = 0;
		ТабДокумент.ПолеСнизу               = 0;
		ТабДокумент.ПолеСправа              = 0;
		ТабДокумент.РазмерКолонтитулаСверху = 10;
		ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
		//ТабДокумент.АвтоМасштаб             = Истина;
		
		// Загрузим настройки пользователя
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияНМА_НА4";

		// Выведем шапку документа
		//СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Док.Организация, Док.Дата);
		//
		Шапка.Параметры.Заполнить(Док);
		Шапка.Параметры.НаименованиеПолноеОрганизации 	= Док.ОрганизацияНаименованиеПолное;
		//Шапка.Параметры.ЕДРПОУ 							= УправлениеКонтактнойИнформацией.ПолучитьКодОрганизации(СведенияОбОрганизации);
		// краткий формат дат
		Шапка.Параметры.ДокументОснованиеДата 			= Формат(Док.ДокументОснованиеДата, 		"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		Шапка.Параметры.ДатаНачалаИнвентаризации 		= Формат(Док.ДатаНачалаИнвентаризации, 		"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		Шапка.Параметры.ДатаОкончанияИнвентаризации 	= Формат(Док.ДатаОкончанияИнвентаризации, 	"ДЛФ=DD;Л =" + Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		
		Шапка.Параметры.НомерДок = Док.Номер;
		//Шапка.Параметры.ДатаДокумента  = Док.Дата;
		
		ТабДокумент.Вывести(Шапка);
		
		
		// Проверим, помещаются ли строка над таблицей, заголовок и первая строка.
		ШапкаТаблицы = Новый Массив;
		ШапкаТаблицы.Добавить(ЗаголовокТаблицы);
		ШапкаТаблицы.Добавить(СтрокаТаблицы);
		
		//Если НЕ ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ШапкаТаблицы) Тогда			
		//	// Выведем разрыв страницы
		//	ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		//КонецЕсли;
		
		// Сама таблица
		// Выведем заголовок таблицы	
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		// Выведем строки таблицы
		Для Каждого СтрокаНМА Из ТаблицаНМА Цикл
			
			СтрокаТаблицы.Параметры.Заполнить(СтрокаНМА);
			
			ТабДокумент.Вывести(СтрокаТаблицы);
			
		КонецЦикла;
		
		
		// Подвал - члены комиссии
		НаименованиеЧленовКомиссии = Новый Массив;
		НаименованиеЧленовКомиссии.Добавить("ПредседательКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ПервыйЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ВторойЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ТретийЧленКомиссии");
		Подвал.Параметры.Заполнить(ВыборкаПоКомиссии);
		
		// Сначала выведем членов комиссии из выборки
		Для Каждого ЧленКомиссии Из НаименованиеЧленовКомиссии Цикл
			
			Подвал.Параметры[ЧленКомиссии + "Должность"] 	= ВыборкаПоКомиссии[ЧленКомиссии + "Должность"];
			Подвал.Параметры[ЧленКомиссии + "ФИО"] 			= ВыборкаПоКомиссии[ЧленКомиссии + "ФИО"];
			
		КонецЦикла;
		
		
		// Проверим, помещаются ли шапка подписей и одна подпись
		ПодвалРасписка = Новый Массив;
		ПодвалРасписка.Добавить(Подвал);
		ПодвалРасписка.Добавить(Расписка);
		

		
		ТабДокумент.Вывести(Подвал);
		
		Расписка.Параметры.НомерДок = Док.Номер;
		
		ТабДокумент.Вывести(Расписка);
	КонецЦикла; 
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьНА4()

#КонецОбласти

#КонецОбласти

#КонецЕсли
