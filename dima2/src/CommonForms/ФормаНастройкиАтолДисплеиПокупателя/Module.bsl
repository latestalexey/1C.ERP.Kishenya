
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:';uk='Устаткування:'") + Символы.НПП  + Строка(Идентификатор);

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокМодель = Элементы.Модель.СписокВыбора;
	СписокМодель.Добавить("Datecs DPD-201");
	СписокМодель.Добавить("EPSON-совместимый");
	СписокМодель.Добавить("Меркурий ДП-01");
	СписокМодель.Добавить("Меркурий ДП-02");
	СписокМодель.Добавить("Меркурий ДП-03");
	СписокМодель.Добавить("Flytech");
	СписокМодель.Добавить("GIGATEK DSP800");
	СписокМодель.Добавить("GIGATEK DSP850A");
	СписокМодель.Добавить("Штрих-FrontMaster");
	СписокМодель.Добавить("EPSON-совместимый (USA)");
	СписокМодель.Добавить("EPSON USA (POSIFLEX PD302C)");
	СписокМодель.Добавить("Posiflex PD2300 USB");
	СписокМодель.Добавить("IPC");
	СписокМодель.Добавить("GIGATEK DSP820");
	СписокМодель.Добавить("TEC LIUST-51");
	СписокМодель.Добавить("OMRON DP75-21");
	СписокМодель.Добавить("NCR 597X");
	СписокМодель.Добавить("Штрих-miniPOSII PRO");
	СписокМодель.Добавить("Posiflex PD-201/PD-309/PD-320"); 
	СписокМодель.Добавить("Демо-дисплей");

	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 64 Цикл // 1001 - COM1
		СписокПорт.Добавить(1000 + Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;
	СписокПорт.Добавить(66, "Posiflex USB");
	СписокПорт.Добавить(101, "ComProxy 1");
	СписокПорт.Добавить(102, "ComProxy 2");

	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(4,  "2400");
	СписокСкорость.Добавить(5,  "4800");
	СписокСкорость.Добавить(7,  "9600");

	СписокСкорость.Добавить(9,  "14400");
	СписокСкорость.Добавить(10, "19200");
	СписокСкорость.Добавить(11, "38400");
	СписокСкорость.Добавить(12, "57600");
	СписокСкорость.Добавить(13, "115200");

	СписокЧетность = Элементы.Четность.СписокВыбора;
	СписокЧетность.Добавить(0, НСтр("ru='Нет';uk='Ні'"));
	СписокЧетность.Добавить(1, НСтр("ru='Нечетность';uk='Непарність'"));
	СписокЧетность.Добавить(2, НСтр("ru='Четность';uk='Парність'"));
	СписокЧетность.Добавить(3, НСтр("ru='Установлен';uk='Встановлений'"));
	СписокЧетность.Добавить(4, НСтр("ru='Сброшен';uk='Скинутий'"));

	СписокБитыДанных = Элементы.БитыДанных.СписокВыбора;
	СписокБитыДанных.Добавить(3, "7 бит");
	СписокБитыДанных.Добавить(4, "8 бит");

	СписокСтопБиты = Элементы.СтопБиты.СписокВыбора;
	СписокСтопБиты.Добавить(0, "1 бит");
	СписокСтопБиты.Добавить(2, "2 бита");

	СписокКодировка = Элементы.Кодировка.СписокВыбора;
	СписокКодировка.Добавить(437, НСтр("ru='437 (OEM - США)';uk='437 (OEM - США)'"));
	СписокКодировка.Добавить(850, НСтр("ru='850 (OEM - многоязычная латиница 1)';uk='850 (OEM - багатомовна латиниця 1)'"));
	СписокКодировка.Добавить(852, НСтр("ru='852 (OEM - кириллица традиционная)';uk='852 (OEM - кирилиця традиційна)'"));
	СписокКодировка.Добавить(860, НСтр("ru='860 (OEM - португальский)';uk='860 (OEM - португальська)'"));
	СписокКодировка.Добавить(863, НСтр("ru='863 (OEM - франко-канадский)';uk='863 (OEM - франко-канадська)'"));
	СписокКодировка.Добавить(865, НСтр("ru='865 (OEM - скандинавский)';uk='865 (OEM - скандинавська)'"));
	СписокКодировка.Добавить(866, НСтр("ru='866 (OEM - русский)';uk='866 (OEM - російська)'"));
	СписокКодировка.Добавить(932, НСтр("ru='932 (ANSI/OEM - японский Shift-JIS)';uk='932 (ANSI/OEM - японська Shift-JIS)'"));
	СписокКодировка.Добавить(988, "988 (ASCII)");

	СписокРазмерДисплея = Элементы.РазмерДисплея.СписокВыбора;
	СписокРазмерДисплея.Добавить(0, "20х2");
	СписокРазмерДисплея.Добавить(1, "16х1");
	СписокРазмерДисплея.Добавить(2, "26х2");
	
	времПорт            = Неопределено;
	времСкорость        = Неопределено;
	времЧетность        = Неопределено;
	времБитыДанных      = Неопределено;
	времСтопБиты        = Неопределено;
	времКодировка       = Неопределено;
	времЗагружатьШрифты = Неопределено;
	времМодель          = Неопределено;
	времРазмерДисплея   = Неопределено;

	Параметры.ПараметрыОборудования.Свойство("Порт",            времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость",        времСкорость);
	Параметры.ПараметрыОборудования.Свойство("Четность",        времЧетность);
	Параметры.ПараметрыОборудования.Свойство("БитыДанных",      времБитыДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБиты",        времСтопБиты);
	Параметры.ПараметрыОборудования.Свойство("Кодировка",       времКодировка);
	Параметры.ПараметрыОборудования.Свойство("ЗагружатьШрифты", времЗагружатьШрифты);
	Параметры.ПараметрыОборудования.Свойство("Модель",          времМодель);
	Параметры.ПараметрыОборудования.Свойство("РазмерДисплея",   времРазмерДисплея);

	Порт            = ?(времПорт            = Неопределено, 1001, времПорт);
	Скорость        = ?(времСкорость        = Неопределено,    7, времСкорость);
	Четность        = ?(времЧетность        = Неопределено,    0, времЧетность);
	БитыДанных      = ?(времБитыДанных      = Неопределено,    4, времБитыДанных);
	СтопБиты        = ?(времСтопБиты        = Неопределено,    0, времСтопБиты);
	Кодировка       = ?(времКодировка       = Неопределено,  866, времКодировка);
	РазмерДисплея	= ?(времРазмерДисплея   = Неопределено,    0, времРазмерДисплея);
	ЗагружатьШрифты = ?(времЗагружатьШрифты = Неопределено, Ложь, времЗагружатьШрифты);
	Модель          = ?(времМодель          = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	УстановитьДоступностьЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МодельПриИзменении(Элемент)

	УстановитьДоступностьЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	
	НовыеЗначениеПараметров.Вставить("Порт"            , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"        , Скорость);
	НовыеЗначениеПараметров.Вставить("Четность"        , Четность);
	НовыеЗначениеПараметров.Вставить("БитыДанных"      , БитыДанных);
	НовыеЗначениеПараметров.Вставить("СтопБиты"        , СтопБиты);
	НовыеЗначениеПараметров.Вставить("Кодировка"       , Кодировка);
	НовыеЗначениеПараметров.Вставить("ЗагружатьШрифты" , ЗагружатьШрифты);
	НовыеЗначениеПараметров.Вставить("Модель"          , Модель);
	НовыеЗначениеПараметров.Вставить("РазмерДисплея"   , РазмерДисплея);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	Текст = НСтр("ru='Установка производиться средствами дистрибутива поставщика.
        |Перейти на сайт поставщика для скачивания?'
        |;uk='Встановлення проводитися засобами дистрибутиву постачальника.
        |Перейти на сайт постачальника для скачування?'");
	Оповещение = Новый ОписаниеОповещения("УстановкаДрайвераЗавершение",  ЭтотОбъект);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("Кодировка"      , Кодировка);
	времПараметрыУстройства.Вставить("ЗагружатьШрифты", ЗагружатьШрифты);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("РазмерДисплея"  , РазмерДисплея);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru='Тест успешно выполнен.';uk='Тест успішно виконаний.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru='Дополнительное описание:';uk='Додатковий опис:'") + " " + ВыходныеПараметры[1],
		                           "");


		ТекстСообщения = НСтр("ru='Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%';uk='Тест не пройдено.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	ДоступностьЗагружатьШрифты = (Модель = "EPSON-совместимый") Или (Модель = "Штрих-FrontMaster");
	ДоступностьПараметрыПорта  = (Модель <> "Демо-дисплей");
	
	Элементы.ЗагружатьШрифты.Доступность   = ДоступностьЗагружатьШрифты;
	Элементы.Порт.Доступность              = ДоступностьПараметрыПорта;
	Элементы.Скорость.Доступность          = ДоступностьПараметрыПорта;
	Элементы.Четность.Доступность          = ДоступностьПараметрыПорта;
	Элементы.БитыДанных.Доступность        = ДоступностьПараметрыПорта;
	Элементы.СтопБиты.Доступность          = ДоступностьПараметрыПорта;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("Кодировка"      , Кодировка);
	времПараметрыУстройства.Вставить("ЗагружатьШрифты", ЗагружатьШрифты);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("РазмерДисплея"  , РазмерДисплея);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена';uk='Не визначена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен';uk='Не встановлений'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена';uk='Не визначена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен';uk='Встановлений'"));

КонецПроцедуры

#КонецОбласти