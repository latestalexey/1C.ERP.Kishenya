
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
	
	СписокПорт = Элементы.Порт.СписокВыбора;
	СписокПорт.Добавить(100, НСтр("ru='<Клавиатура>';uk='<Клавіатура>'"));
	Для Индекс = 1 По 64 Цикл
		СписокПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(1,  "300");
	СписокСкорость.Добавить(2,  "600");
	СписокСкорость.Добавить(3,  "1200");
	СписокСкорость.Добавить(4,  "2400");
	СписокСкорость.Добавить(5,  "4800");
	СписокСкорость.Добавить(7,  "9600");
	СписокСкорость.Добавить(9,  "14400");
	СписокСкорость.Добавить(10, "19200");
	СписокСкорость.Добавить(12, "38400");
	
	СписокБитДанных = Элементы.БитДанных.СписокВыбора;
	СписокБитДанных.Добавить(3, НСтр("ru='7 бит';uk='7 біт'"));
	СписокБитДанных.Добавить(4, НСтр("ru='8 бит';uk='8 біт'"));
	
	СписокСтопБит = Элементы.СтопБит.СписокВыбора;
	СписокСтопБит.Добавить(0, НСтр("ru='1 стоп-бит';uk='1 стоп-біт'"));
	СписокСтопБит.Добавить(2, НСтр("ru='2 стоп-бита';uk='2 стоп-біта'"));
	
	СписокЧетность = Элементы.Четность.СписокВыбора;
	СписокЧетность.Добавить(0, НСтр("ru='Нет';uk='Ні'"));
	СписокЧетность.Добавить(1, НСтр("ru='Нечетность';uk='Непарність'"));
	СписокЧетность.Добавить(2, НСтр("ru='Четность';uk='Парність'"));
	СписокЧетность.Добавить(3, НСтр("ru='Установлен';uk='Встановлений'"));
	СписокЧетность.Добавить(4, НСтр("ru='Сброшен';uk='Скинутий'"));
	
	УстановитьПараметрыШК(Элементы.Префикс);
	УстановитьПараметрыШК(Элементы.Суффикс);

	времПорт             = Неопределено;
	времСкорость         = Неопределено;
	времБитДанных        = Неопределено;
	времСтопБит          = Неопределено;
	времЧетность         = Неопределено;
	времЧувствительность = Неопределено;
	времПрефикс          = Неопределено;
	времСуффикс          = Неопределено;
	времМодель           = Неопределено;

	Параметры.ПараметрыОборудования.Свойство("Порт"             , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"         , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("БитДанных"        , времБитДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБит"          , времСтопБит);
	Параметры.ПараметрыОборудования.Свойство("Четность"         , времЧетность);
	Параметры.ПараметрыОборудования.Свойство("Чувствительность" , времЧувствительность);
	Параметры.ПараметрыОборудования.Свойство("Префикс"          , времПрефикс);
	Параметры.ПараметрыОборудования.Свойство("Суффикс"          , времСуффикс);
	Параметры.ПараметрыОборудования.Свойство("Модель"           , времМодель);

	Порт             = ?(времПорт             = Неопределено,     1, времПорт);
	Скорость         = ?(времСкорость         = Неопределено,     7, времСкорость);
	БитДанных        = ?(времБитДанных        = Неопределено,     3, времБитДанных);
	СтопБит          = ?(времСтопБит          = Неопределено,     0, времСтопБит);
	Четность         = ?(времЧетность         = Неопределено,     0, времЧетность);
	Чувствительность = ?(времЧувствительность = Неопределено,    30, времЧувствительность);
	Префикс          = ?(времПрефикс          = Неопределено,    "", времПрефикс);
	Суффикс          = ?(времСуффикс          = Неопределено, "#13", времСуффикс);
	
	Модель = ?(времМодель = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);
	
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	ПортПриИзменении();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПортПриИзменении()

	Элементы.Скорость.Доступность  = Порт <> 100;
	Элементы.БитДанных.Доступность = Порт <> 100;
	Элементы.СтопБит.Доступность   = Порт <> 100;
	Элементы.Четность.Доступность  = Порт <> 100;

КонецПроцедуры

&НаКлиенте
Процедура ПрефиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение <> Неопределено Тогда
		Префикс = Префикс + ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуффиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение <> Неопределено Тогда
		Суффикс = Суффикс + ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении1(Элемент)

	ПортПриИзменении();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
		
	Если Суффикс <> "" Тогда
		
		НовыеЗначениеПараметров = Новый Структура;
		НовыеЗначениеПараметров.Вставить("Порт"             , Порт);
		НовыеЗначениеПараметров.Вставить("Скорость"         , Скорость);
		НовыеЗначениеПараметров.Вставить("БитДанных"        , БитДанных);
		НовыеЗначениеПараметров.Вставить("СтопБит"          , СтопБит);
		НовыеЗначениеПараметров.Вставить("Четность"         , Четность);
		НовыеЗначениеПараметров.Вставить("Чувствительность" , Чувствительность);
		НовыеЗначениеПараметров.Вставить("Префикс"          , Префикс);
		НовыеЗначениеПараметров.Вставить("Суффикс"          , Суффикс);
		НовыеЗначениеПараметров.Вставить("Модель"           , Модель);
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор", Идентификатор);
		Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
		
		Закрыть(Результат);
		
	Иначе
		ТекстСообщения = НСтр("ru='Не указан суффикс сканера штрихкода. Для идентификации штрихкода суффикс должен быть указан.';uk='Не зазначений суфікс сканера штрихкоду. Для ідентифікації штрихкоду суфікс повинен бути зазначений.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Суффикс");
	КонецЕсли;

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыШК(Элемент)

	Если (Элемент.Имя = "Префикс"
	 Или Элемент.Имя = "Суффикс")
	   И Элемент.СписокВыбора.Количество() = 0 Тогда
		СписокПараметрыДорожек = Элемент.СписокВыбора;

		Для КодЭлемента = 0 По 127 Цикл
			СимволДорожки = "";
			Если КодЭлемента > 32 Тогда
				СимволДорожки = " ( " + Символ(КодЭлемента) + " )";
			ИначеЕсли КодЭлемента = 8 Тогда
				СимволДорожки = " (BACKSPACE)";
			ИначеЕсли КодЭлемента = 9 Тогда
				СимволДорожки = " (TAB)";
			ИначеЕсли КодЭлемента = 10 Тогда
				СимволДорожки = " (LF)";
			ИначеЕсли КодЭлемента = 13 Тогда
				СимволДорожки = " (CR)";
			ИначеЕсли КодЭлемента = 16 Тогда
				СимволДорожки = " (SHIFT)";
			ИначеЕсли КодЭлемента = 17 Тогда
				СимволДорожки = " (CONTROL)";
			ИначеЕсли КодЭлемента = 18 Тогда
				СимволДорожки = " (ALT)";
			ИначеЕсли КодЭлемента = 27 Тогда
				СимволДорожки = " (ESCAPE)";
			ИначеЕсли КодЭлемента = 32 Тогда
				СимволДорожки = " (SPACE)";
			КонецЕсли;
			СписокПараметрыДорожек.Добавить("#" + СокрЛП(КодЭлемента), "#" + СокрЛП(КодЭлемента) + СимволДорожки);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"            , Порт);
	времПараметрыУстройства.Вставить("Скорость"        , Скорость);
	времПараметрыУстройства.Вставить("БитДанных"       , БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"         , СтопБит);
	времПараметрыУстройства.Вставить("Четность"        , Четность);
	времПараметрыУстройства.Вставить("Чувствительность", Чувствительность);
	времПараметрыУстройства.Вставить("Префикс"         , Префикс);
	времПараметрыУстройства.Вставить("Суффикс"         , Суффикс);
	времПараметрыУстройства.Вставить("Модель"          , Модель);

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