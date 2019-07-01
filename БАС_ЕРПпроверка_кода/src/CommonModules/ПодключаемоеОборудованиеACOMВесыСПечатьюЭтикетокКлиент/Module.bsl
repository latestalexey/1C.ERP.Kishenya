
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат      		= Истина;
	ВыходныеПараметры 	= Новый Массив();
	ОбъектДрайвера 		= Неопределено;

	БазаТоваров  = Неопределено;

	Параметры.Свойство("БазаТоваров",  БазаТоваров);

	Если БазаТоваров  = Неопределено Тогда
	 	ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
        |Для корректной работы устройства необходимо задать параметры его работы.'
        |;uk='Не настроєні параметри пристрою.
        |Для коректної роботи пристрою необхідно задати параметри його роботи.'"));
		Результат = Ложь;
	Иначе
		ОбъектДрайвера = Новый Структура("Параметры", Параметры);
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	 
	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	
	// Выгрузка товаров в весы с печатью этикеток.
	Если Команда = "ВыгрузитьТовары" Тогда
		Товары            = ВходныеПараметры[0];
		ЧастичнаяВыгрузка = ВходныеПараметры[1];
		Результат = ВыгрузитьТовары(ОбъектДрайвера, Параметры, ПараметрыПодключения, Товары, ЧастичнаяВыгрузка, ВыходныеПараметры);
	  
	// Очистить базу весов с печатью этикеток.
	ИначеЕсли Команда = "ОчиститьБазу" Тогда
		Результат = ОчиститьТоварыВВесах(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.';uk='Команда ""%Команда%"" не підтримується цим драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет выгрузку таблицы товаров в весы с печатью этикеток.
//
// Параметры:
//  ОбъектДрайвера                 - <*>
//                                 - Объект драйвера торгового оборудования.
//
//  Товары                         - <ТаблицаЗначений>
//                                 - Таблица товаров, подлежащих выгрузке в весы.
//                                   Таблица имеет следующие колонки:
//                                     PLU                        - <Число>
//                                                                - Идентификатор товара в весах.
//									   Штрихкод 				  - <Строка>
//                                                                - Штрихкод товара на кассе.
//                                     Наименование               - <Строка>
//																  - Наименование товара сокращенное (для печати на этикетке).
//                                     НаименованиеПолное         - <Строка>
//																  - Наименование товара полное (для отображения на табло).
//                                     Цена                       - <Число>
//                                                                - Цена номенклатуры.
//
//  ЧастичнаяВыгрузка               - <Булево>
//                                  - Признак частичной выгрузки товара.
//
Функция ВыгрузитьТовары(ОбъектДрайвера, Параметры, ПараметрыПодключения, Товары, ЧастичнаяВыгрузка, ВыходныеПараметры) 
	
	Результат = Истина;
	Префикс = "2" + МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьПрефиксВесовогоТовара(Параметры.Идентификатор);
	Если СтрДлина(Префикс) = 1 Тогда
		Префикс = Префикс + "0";
	КонецЕсли;
	
	Состояние(НСтр("ru='Выполняется выгрузка товаров в весы с печатью этикеток...';uk='Виконується вивантаження товарів у ваги з друком етикеток...'")); 
	
	Файл = Новый ТекстовыйДокумент();
	
	Для каждого текЭлемент Из Товары Цикл
		
		Если ПустаяСтрока(текЭлемент.Код) Или (текЭлемент.Код = 0) Тогда
			КодТовараВрем =  МенеджерОборудованияКлиент.ПостроитьПоле(Формат(текЭлемент.Штрихкод, "ЧГ=0"), 8)
		Иначе
            КодТовараВрем =  МенеджерОборудованияКлиент.ПостроитьПоле(Строка(текЭлемент.Код), 8)
		КонецЕсли;
		
		ВремНаименование = ?(текЭлемент.Свойство("Номенклатура"), текЭлемент.Номенклатура, "");
		ВремНаименование = ?(текЭлемент.Свойство("Наименование"), текЭлемент.Наименование, ВремНаименование);
		Если текЭлемент.Свойство("НаименованиеПолное") И Не ПустаяСтрока(текЭлемент.НаименованиеПолное) Тогда
			ВремНаименование = текЭлемент.НаименованиеПолное;
		КонецЕсли;
		
		Если текЭлемент.Свойство("СрокХранения") Тогда	
			СрокХраненияВрем = текЭлемент.СрокХранения;
		Иначе
			СрокХраненияВрем = 0;
		КонецЕсли;
		
		Если текЭлемент.Свойство("ОписаниеТовара") Тогда	
			ОписаниеТовараВрем = текЭлемент.ОписаниеТовара;
		Иначе
			ОписаниеТовараВрем = "";
		КонецЕсли;
			
		Строка =  МенеджерОборудованияКлиент.ПостроитьПоле(Формат(текЭлемент.PLU, "ЧГ=0"), 8) + "|" 					// PLU (8)
		+  МенеджерОборудованияКлиент.ПостроитьПоле(ВремНаименование, 30) + "|" 										// Наименование1 (30)
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Сред(ВремНаименование, 31, 30), 30) + "|"							// Наименование2 (30)
		// Цена (10)
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Формат(текЭлемент.Цена * 100, "ЧЦ=8; ЧДЦ=0; ЧН=0; ЧГ=0"), 15) + "|"
		// Срок хранения (5)
		+ ?(СрокХраненияВрем = 0, "   ",  МенеджерОборудованияКлиент.ПостроитьПоле(Формат(СрокХраненияВрем, "ЧН=0; ЧГ=0"), 3)) + "|"
		+ "       |"																				// Вес тары (7)
		+ "     |"																					// Использовать до (5)
		+ КодТовараВрем + "|"																		// Код товара (8)
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Формат(Префикс, "ЧН=0; ЧГ=0"), 4) + "|"								// Код группы (4)
		+ "     |"																					// Код Производителя (5)
		+ "   |"																					// ПЛУ Тип (3)
		+ "   |"																		// КодЗаголовка (3)
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Сред(ОписаниеТовараВрем, 1,   56), 56) + "|"				// Состав1 58
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Сред(ОписаниеТовараВрем, 57,  56), 56) + "|"				// Состав2 58
		+  МенеджерОборудованияКлиент.ПостроитьПоле(Сред(ОписаниеТовараВрем, 113, 56), 56) + "|"				// Состав3 58
		+ "                                                        |"					// Состав4 58
		+ "                                                        |"					// Состав5 58
		+ "                                                        |"					// Состав6 58
		+ "                                                        |"					// Состав7 58
		+ "                                                        |"					// Состав8 58
		+ "                                                        |"					// Состав9 58
		+ "                                                        ";					// Состав10 58
		Файл.ДобавитьСтроку(Строка);
	КонецЦикла;
	
	Попытка
		Файл.Записать(Параметры.БазаТоваров, КодировкаТекста.ANSI);
	Исключение
		ВыходныеПараметры.Добавить(999);
		ОписаниеОшибки = НСтр("ru='Не удалось записать файл товаров по адресу: %Адрес%';uk='Не вдалося записати файл товарів за адресою: %Адрес%'");
		ВыходныеПараметры.Добавить(СтрЗаменить(ОписаниеОшибки, "%Адрес%", Параметры.БазаТоваров));
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет очистку таблицы товаров в весы с печатью этикеток.
//
Функция ОчиститьТоварыВВесах(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) 

	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(НСтр("ru='Данные весы не поддерживают автоматическую очистку товаров.
    | Для очистки товаров в весах запустите приложение загрузки 
    | данных в весы и нажмите кнопку ""Очистить PLU в весах""'
    |;uk='Дані ваги не підтримують автоматичне очищення товарів.
    |Для очищення товарів в вагах запустіть програму завантаження 
    |даних у ваги і натисніть кнопку ""Очистити PLU у вагах""'"));
	Результат = Ложь;

	Возврат Результат;

КонецФункции

// Функция осуществляет проверку путей по которым хранятся файлы обмена.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) 
	
	Результат = Истина;
	Каталог = Неопределено;
	ТекстОшибки = "";
	
	ВремБазаТоваров = "";
	Параметры.Свойство("БазаТоваров", ВремБазаТоваров);
	
	Если ПустаяСтрока(ВремБазаТоваров) Тогда
		Результат = Ложь;
		ТекстОшибки = НСтр("ru='Файл базы товаров не указан.';uk='Файл бази даних товарів не зазначено.'");
	КонецЕсли;
		
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		ВыходныеПараметры.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти