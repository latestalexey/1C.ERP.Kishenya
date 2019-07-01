Функция ПолучитьСвойстваСчета(Знач Счет) Экспорт

	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Ссылка"                         , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Наименование"                   , "");
	ДанныеСчета.Вставить("Код"                            , "");
	ДанныеСчета.Вставить("КодБыстрогоВыбора"              , "");
	ДанныеСчета.Вставить("Родитель"                       , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Вид"                            , Неопределено);
	ДанныеСчета.Вставить("Забалансовый"                   , Ложь);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках", Ложь);
	ДанныеСчета.Вставить("Валютный"                       , Ложь);
	ДанныеСчета.Вставить("Количественный"                 , Ложь);
	ДанныеСчета.Вставить("УчетПоПодразделениям"           , Ложь);
	ДанныеСчета.Вставить("НалоговыйУчет"                  , Ложь);
	ДанныеСчета.Вставить("КоличествоСубконто"             , 0);
	ДанныеСчета.Вставить("УчетПоНалоговымНазначениямНДС"  , Ложь);
	
	МаксКоличествоСубконто	= ПолучитьМаксКоличествоСубконто();
	
	Для ИндексСубконто = 1 По МаксКоличествоСубконто Цикл
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      Ложь);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", Ложь);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат ДанныеСчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка,
	|	Хозрасчетный.Родитель,
	|	Хозрасчетный.Код,
	|	Хозрасчетный.КодБыстрогоВыбора,
	|	Хозрасчетный.Наименование,
	|	Хозрасчетный.Вид,
	|	Хозрасчетный.Забалансовый,
	|	Хозрасчетный.ЗапретитьИспользоватьВПроводках,
	|	Хозрасчетный.Валютный,
	|	Хозрасчетный.Количественный,
	|	Хозрасчетный.УчетПоПодразделениям,
	|	Хозрасчетный.УчетПоНалоговымНазначениямНДС,
	|	Хозрасчетный.НалоговыйУчет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.Наименование КАК Наименование,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения,
	|	ХозрасчетныйВидыСубконто.ТолькоОбороты КАК ТолькоОбороты,
	|	ХозрасчетныйВидыСубконто.Суммовой КАК Суммовой
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.Ссылка = &Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ХозрасчетныйВидыСубконто.НомерСтроки";
	
	МассивРезультатов	= Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеСчета, Выборка);
	КонецЕсли;
		
	ВыборкаВидыСубконто	= МассивРезультатов[1].Выбрать();
		
	ДанныеСчета.КоличествоСубконто	= ВыборкаВидыСубконто.Количество();
		
	ИндексСубконто	= 0;
		
	Пока ВыборкаВидыСубконто.Следующий() Цикл
		
		ИндексСубконто	= ИндексСубконто + 1;
		
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   ВыборкаВидыСубконто.ВидСубконто);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  ВыборкаВидыСубконто.Наименование);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   ВыборкаВидыСубконто.ТипЗначения);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      ВыборкаВидыСубконто.Суммовой);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", ВыборкаВидыСубконто.ТолькоОбороты);
		
	КонецЦикла;
	
	Возврат ДанныеСчета;
	
КонецФункции

Функция ПолучитьМаксКоличествоСубконто() Экспорт

	Возврат Метаданные.ПланыСчетов.Хозрасчетный.МаксКоличествоСубконто;

КонецФункции

Функция ВедетсяУчетПоСкладам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоСкладам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады;

	Возврат УчетПоСкладам;

КонецФункции 

Функция ВедетсяСуммовойУчетПоСкладам(Счет) Экспорт

	СвойстваСчета      = ПолучитьСвойстваСчета(Счет);

	Если СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто1Суммовой;
	ИначеЕсли СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто2Суммовой;
	ИначеЕсли СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто3Суммовой;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция НаСчетеВедетсяПартионныйУчет(Счет) Экспорт

	Возврат Ложь;

КонецФункции 

Функция КомиссионныйТовар(Счет) Экспорт

	Комиссионный = ТипЗнч(Счет) = Тип("ПланСчетовСсылка.Хозрасчетный")
		И Счет <> ПланыСчетов.Хозрасчетный.ПустаяСсылка()
		И Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссиюВсего);		

	Возврат Комиссионный;

КонецФункции


Функция НаСчетеВедетсяУчетПоДокументамРасчетов(Счет) Экспорт

	Возврат Ложь;

КонецФункции

Функция НаСчетеВедетсяУчетПоКонтрагентам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоКонтрагентам = СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты
		ИЛИ СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;

	Возврат УчетПоКонтрагентам;

КонецФункции 

Функция НаСчетеВедетсяУчетПоДоговорам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоДоговорам = СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры
		ИЛИ СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;

	Возврат УчетПоДоговорам;

КонецФункции

Функция НаСчетеВедетсяУчетПоНоменклатурнымГруппам(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоНомГруппам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы;

	Возврат УчетПоНомГруппам;

КонецФункции

Функция НаСчетеВедетсяУчетПоСтатьямЗатрат(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоСтатьямЗатрат = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат;

	Возврат УчетПоСтатьямЗатрат;

КонецФункции

Функция СчетВИерархии(Счет, Эталон) Экспорт

	Если ЗначениеЗаполнено(Счет) Тогда
		Возврат Счет = Эталон ИЛИ Счет.ПринадлежитЭлементу(Эталон);
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция СчетаВИерархии(СчетГруппа) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СчетГруппа) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетГруппа", СчетГруппа);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетГруппа)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");

КонецФункции

// Определяет счет учета материалов, переданных в переработку
Функция СчетУчетаМатериалыПереданныеВПереработку(Знач СчетВыбранныйПользователем = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СчетВыбранныйПользователем)
		И СчетВыбранныйПользователем.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку) Тогда
		Возврат СчетВыбранныйПользователем;
	Иначе
		Возврат ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку;
	КонецЕсли;
	
КонецФункции

// Определяет счет учета материалов, принятых в переработку и затем использованных
Функция СчетУчетаМатериалыПринятыеВПереработкуВПроизводстве(Знач СчетВыбранныйПользователем = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СчетВыбранныйПользователем) Тогда
		Возврат СчетВыбранныйПользователем;
	Иначе
		Возврат ПланыСчетов.Хозрасчетный.МатериалыПринятыеВПереработкуВПроизводстве;
	КонецЕсли;
	
КонецФункции

// Функция возвращает типы значений субконто, связанных с именами реквизитов
//
// Возвращаемое значение:
//   Соответствие   - ключ - имя реквизита, значение - описание типов связанных значений субконто
//
Функция ВсеТипыСвязанныхСубконто() Экспорт
	
	СвязанныеСубконто = Новый Соответствие;
	
	БухгалтерскийУчетПереопределяемый.УстановитьТипыСвязанныхСубконто(СвязанныеСубконто);
	
	Возврат СвязанныеСубконто;
	
КонецФункции


Функция ЭтоСчетРасчетыСПерсоналомПоОплатеТруда(Знач Счет) Экспорт
	
	Возврат (Счет = ПланыСчетов.Хозрасчетный.РасчетыПоЗаработнойПлате);
	
КонецФункции


Функция ЭтоСубконтоСтатьиЗатрат(Знач ВидСубконто) Экспорт
	
	Возврат (ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат);

КонецФункции


Функция ЭтоСчетКапитализацииРасходовПоВНА(Счет) Экспорт
	
	Результат =
		(Счет = ПланыСчетов.Хозрасчетный.ПриобретениеОсновныхСредств
		ИЛИ Счет = ПланыСчетов.Хозрасчетный.ИзготовлениеОсновныхСредств
		ИЛИ Счет = ПланыСчетов.Хозрасчетный.КапитальноеСтроительство
		ИЛИ Счет = ПланыСчетов.Хозрасчетный.ПриобретениеДругихНеоборотныхМатериальныхАктивов
		ИЛИ Счет = ПланыСчетов.Хозрасчетный.ИзготовлениеДругихНеоборотныхМатериальныхАктивов
		ИЛИ Счет = ПланыСчетов.Хозрасчетный.ПриобретениеНематериальныхАктивов
		);
		
	Возврат Результат;
КонецФункции

Функция ЭтоСубконтоОбъектВНА(Знач ВидСубконто) Экспорт
	
	Возврат (ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства
				ИЛИ ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства
				ИЛИ ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НематериальныеАктивы);
	
КонецФункции

Функция Счет8КлассаПоТипуЗатрат(Знач ТипЗатрат) Экспорт
	
	Результат = Неопределено;
	Если ТипЗатрат = Перечисления.ТипыЗатратРегл.Работы Тогда
		Результат = ПланыСчетов.Хозрасчетный.ДругиеМатериальныеЗатраты;
	ИначеЕсли ТипЗатрат = Перечисления.ТипыЗатратРегл.СдельнаяОплатаТруда Тогда
		Результат = ПланыСчетов.Хозрасчетный.ВыплатыПоОкладамИТарифам;
	ИначеЕсли ТипЗатрат = Перечисления.ТипыЗатратРегл.МатериальныеЗатраты Тогда
		Результат = ПланыСчетов.Хозрасчетный.НоменклатурныеМатериальныеЗатратыВПроизводстве;
	ИначеЕсли ТипЗатрат = Перечисления.ТипыЗатратРегл.Прочее Тогда
		Результат = ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты;	
	КонецЕсли; 
	
	Возврат Результат;

КонецФункции

