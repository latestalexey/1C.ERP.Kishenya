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
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.Вставить("РазрешеноМенятьВарианты", Ложь);
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Создание команды
	ИмяКоманды = "";
	ЗаголовокКоманды = "";
	ПодсказкаКоманды = "";
	Если ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного") Тогда
		ИмяКоманды = "НастройкаСоответствияСчетовИОборотов";
		ЗаголовокКоманды = НСтр("ru='Настройка соответствия счетов и оборотов';uk='Настройка відповідності рахунків і оборотів'");
		ПодсказкаКоманды = НСтр("ru='Открыть форму настройки соответствия счетов и оборотов.';uk='Відкрити форму настройки відповідності рахунків і оборотів.'");
	Иначе
		ИмяКоманды = "НастройкаСоответствияСчетов";
		ЗаголовокКоманды = НСтр("ru='Настройка соответствия счетов';uk='Настройка відповідності рахунків'");
		ПодсказкаКоманды = НСтр("ru='Открыть форму настройки соответствия счетов.';uk='Відкрити форму настройки відповідності рахунків.'");
	КонецЕсли;
	
	КомандаНастройкаСоответствия = ЭтаФорма.Команды.Добавить(ИмяКоманды);
	КомандаНастройкаСоответствия.Действие = "Подключаемый_Команда";
	КомандаНастройкаСоответствия.Заголовок = ЗаголовокКоманды;
	КомандаНастройкаСоответствия.Подсказка = ПодсказкаКоманды;
	
	ЭтаФорма.ПостоянныеКоманды.Добавить(ИмяКоманды);
	
	// Добавление кнопки вызова команды
	КнопкаНастройкаСоответствия = ЭтаФорма.Элементы.Вставить(ИмяКоманды,
															Тип("КнопкаФормы"),
															ЭтаФорма.Элементы.ОсновнаяКоманднаяПанель,
															ЭтаФорма.Элементы.ГруппаНастройкиОтчета);
	КнопкаНастройкаСоответствия.ИмяКоманды = ИмяКоманды;
	
	КнопкаНастройкаСоответствия.ТолькоВоВсехДействиях = Ложь;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//настроим представления счетов
	Параметр = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВыводитьНаименованиеСчета");
	ВыводитьНаименованиеСчета = Истина;
	Если Параметр <> Неопределено Тогда
		ВыводитьНаименованиеСчета = Параметр.Значение;
	КонецЕсли;
	
	ПолеСчета = СхемаКомпоновкиДанных.НаборыДанных.ОСВ_Счетов.Поля.Найти("СчетМУ");
	Если ПолеСчета <> Неопределено Тогда
		ПолеСчета.ВыражениеПредставления = ?(ВыводитьНаименованиеСчета,"СчетМУ.Код+"", ""+СчетМУ.Наименование","СчетМУ.Код");
	КонецЕсли;
	
	ПолеСчета = СхемаКомпоновкиДанных.НаборыДанных.ОСВ_Счетов.Поля.Найти("СчетБУ");
	Если ПолеСчета <> Неопределено Тогда
		ПолеСчета.ВыражениеПредставления = ?(ВыводитьНаименованиеСчета,"СчетБУ.Код+"", ""+СчетБУ.Наименование","СчетБУ.Код");
	КонецЕсли;
	
	ДокументРезультат.Очистить();
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиКомпоновкиДанных,
		ДанныеРасшифровки);
	
	СоответствиеСчетов = ПолучитьТаблицуСоответствияСчетов();
	ВнешниеНаборыДанных = Новый Структура("ТаблицаСоответствия", СоответствиеСчетов);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	ПостОбработка(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ПолучитьТаблицуСоответствияСчетов()
	
	// получим плоскую таблицу соответствия счетов один к одному
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоотвествующиеСчета.СчетМУ,
	|	СоотвествующиеСчета.СчетБУ,
	|	СоотвествующиеСчета.КодМУ,
	|	СоотвествующиеСчета.КодБУ
	|ИЗ
	|	(ВЫБРАТЬ
	|		СоответствияСчетов.СчетМеждународногоУчета КАК СчетМУ,
	|		СоответствияСчетов.СчетРеглУчета КАК СчетБУ,
	|		СоответствияСчетов.СчетМеждународногоУчета.Код КАК КодМУ,
	|		СоответствияСчетов.СчетРеглУчета.Код КАК КодБУ
	|	ИЗ
	|		Справочник.СоответствияСчетовМеждународногоУчета КАК СоответствияСчетов
	|	ГДЕ
	|		НЕ СоответствияСчетов.ПометкаУдаления
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СоответствияОборотов.СчетМеждународногоУчетаДт,
	|		СоответствияОборотов.СчетРеглУчетаДт,
	|		СоответствияОборотов.СчетМеждународногоУчетаДт.Код,
	|		СоответствияОборотов.СчетРеглУчетаДт.Код
	|	ИЗ
	|		Справочник.СоответствияОборотовМеждународногоУчета КАК СоответствияОборотов
	|	ГДЕ
	|		НЕ СоответствияОборотов.ПометкаУдаления
	|		И &ПроводкиПоДаннымРеглУчета
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СоответствияОборотов.СчетМеждународногоУчетаКт,
	|		СоответствияОборотов.СчетРеглУчетаКт,
	|		СоответствияОборотов.СчетМеждународногоУчетаКт.Код,
	|		СоответствияОборотов.СчетРеглУчетаКт.Код
	|	ИЗ
	|		Справочник.СоответствияОборотовМеждународногоУчета КАК СоответствияОборотов
	|	ГДЕ
	|		НЕ СоответствияОборотов.ПометкаУдаления
	|		И &ПроводкиПоДаннымРеглУчета
	|	) КАК СоотвествующиеСчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	СоотвествующиеСчета.КодМУ,
	|	СоотвествующиеСчета.КодБУ";
	Запрос.УстановитьПараметр("ПроводкиПоДаннымРеглУчета", 
		ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного"));
	
	ТаблицаСоответствия = Запрос.Выполнить().Выгрузить();
	
	// получим группы соответствия счетов многие ко многим
	СоответствиеСчетов = Новый ТаблицаЗначений;
	СоответствиеСчетов.Колонки.Добавить("СчетМУ", Новый ОписаниеТипов("ПланСчетовСсылка.Международный"));
	СоответствиеСчетов.Колонки.Добавить("СчетБУ", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	СоответствиеСчетов.Колонки.Добавить("КодыМУ", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(1000)));
	СоответствиеСчетов.Колонки.Добавить("КодыБУ", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(1000)));
	
	ГруппаСчетов = НоваяГруппаСчетов();
	ГруппаСчетов.Вставить("СоответствиеСчетов", СоответствиеСчетов);	
	РазложитьСчетаПоГруппам(ТаблицаСоответствия, ГруппаСчетов, ТаблицаСоответствия);
	
	// добавим счета без соответствия
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоответствиеСчетов.КодыМУ,
	|	СоответствиеСчетов.КодыБУ,
	|	СоответствиеСчетов.СчетМУ,
	|	СоответствиеСчетов.СчетБУ
	|ПОМЕСТИТЬ втСоответствие
	|ИЗ
	|	&СоответствиеСчетов КАК СоответствиеСчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Международный.Ссылка, ЗНАЧЕНИЕ(ПланСчетов.Международный.ПустаяСсылка)) КАК СчетМУ,
	|	ЕСТЬNULL(втСоответствие.КодыМУ, &БезСоответствия) КАК КодыМУ,
	|	ЕСТЬNULL(Хозрасчетный.Ссылка, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) КАК СчетБУ,
	|	ЕСТЬNULL(втСоответствие.КодыБУ, &БезСоответствия) КАК КодыБУ
	|ИЗ
	|	ПланСчетов.Международный КАК Международный
	|		ПОЛНОЕ СОЕДИНЕНИЕ втСоответствие КАК втСоответствие
	|			ПОЛНОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|			ПО (Хозрасчетный.Ссылка = втСоответствие.СчетБУ)
	|		ПО Международный.Ссылка = втСоответствие.СчетМУ";
	
	Запрос.УстановитьПараметр("БезСоответствия", НСтр("ru='Без соответствия';uk='Без відповідності'"));
	Запрос.УстановитьПараметр("СоответствиеСчетов", ГруппаСчетов.СоответствиеСчетов);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

Процедура РазложитьСчетаПоГруппам(НаборСчетов, ГруппаСчетов, ТаблицаСоответствия)
	
	Для Каждого Пара Из НаборСчетов Цикл
		
		Если НЕ ЗначениеЗаполнено(Пара.СчетМУ) Тогда
			Продолжить;
		КонецЕсли;
		
		НайтиСоответствиеСчета(ТаблицаСоответствия,Пара,ГруппаСчетов,"МУ",1);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура НайтиСоответствиеСчета(ТаблицаСоответствия,Пара,ГруппаСчетов,ВидУчета,Уровень)
	
	Код = Пара["Код"+ВидУчета];
	Счет = Пара["Счет"+ВидУчета];
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат;
	КонецЕсли;
	СпискоСчетов = ГруппаСчетов["Счета" + ВидУчета];
	Если СпискоСчетов.НайтиПоЗначению(Счет) = Неопределено Тогда
		
		СпискоСчетов.Добавить(Счет, Код);
		
		Отбор = Новый Структура("Счет"+ВидУчета, Пара["Счет"+ВидУчета]);
		МассивСчетов = ТаблицаСоответствия.НайтиСтроки(Отбор);
		ВидУчета2 = ?(ВидУчета = "МУ", "БУ", "МУ");		
		Для Каждого стр Из МассивСчетов Цикл
			НайтиСоответствиеСчета(ТаблицаСоответствия,стр,ГруппаСчетов,ВидУчета2,Уровень+1);
			стр.СчетМУ = Неопределено;
			стр.СчетБУ = Неопределено;
		КонецЦикла;
		Если Уровень = 1 Тогда
			ЗаписатьГруппу(ГруппаСчетов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьГруппу(ГруппаСчетов)
	
	ГруппаСчетов.КодыМУ = ПолучитьКодыГруппыСчетов(ГруппаСчетов, "МУ");
	ГруппаСчетов.КодыБУ = ПолучитьКодыГруппыСчетов(ГруппаСчетов, "БУ");
	
	ЗаписатьСчета(ГруппаСчетов, "МУ");	
	ЗаписатьСчета(ГруппаСчетов, "БУ");
	
	НоваяГруппаСчетов(ГруппаСчетов);	
	
КонецПроцедуры

Функция ПолучитьКодыГруппыСчетов(ГруппаСчетов, ВидУчета)
	
	СпискоСчетов = ГруппаСчетов["Счета"+ВидУчета];
	СпискоСчетов.СортироватьПоПредставлению();
	Коды = "";
	Для Каждого Счет Из СпискоСчетов Цикл
		
		Коды = Коды + Счет.Представление + "; ";
		
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Коды,2);
	Возврат Коды;
	
КонецФункции

Процедура ЗаписатьСчета(ГруппаСчетов, ВидУчета)
	
	СпискоСчетов = ГруппаСчетов["Счета"+ВидУчета];
	Для Каждого Счет Из СпискоСчетов Цикл
		НоваяСтрока = ГруппаСчетов.СоответствиеСчетов.Добавить();
		НоваяСтрока["КодыМУ"] = ГруппаСчетов["КодыМУ"];
		НоваяСтрока["КодыБУ"] = ГруппаСчетов["КодыБУ"];
		НоваяСтрока["Счет"+ВидУчета] = Счет.Значение;
	КонецЦикла;
	
КонецПроцедуры

Функция НоваяГруппаСчетов(ГруппаСчетов = Неопределено)
	
	Если ГруппаСчетов <> Неопределено Тогда
		ГруппаСчетов.КодыМУ = "";
		ГруппаСчетов.КодыБУ = "";
		ГруппаСчетов.СчетаМУ = Новый СписокЗначений;
		ГруппаСчетов.СчетаБУ = Новый СписокЗначений;
	КонецЕсли;
	
	Возврат Новый Структура("КодыМУ,КодыБУ,СчетаМУ,СчетаБУ","","",Новый СписокЗначений,Новый СписокЗначений);
	
КонецФункции

#КонецОбласти

#Область ДоработкаТабличногоДокумента

Процедура ПостОбработка(ДокументРезультат)
	
	ВалютыНеСовпадают = Константы.ВалютаРегламентированногоУчета.Получить() <> Константы.ВалютаФункциональная.Получить();
	
	ДокументРезультат.ЧерноБелаяПечать = Истина;
	ДокументРезультат.ФиксацияСлева = 2;
	ПоказатьУровеньГруппировкиСтрок(ДокументРезультат);
	
	Область = ДокументРезультат.НайтиТекст("Обычная");
	УстановитьГруппировкуКолонок(ДокументРезультат, НСтр("ru='Дебетовый оборот МУ';uk='Дебетовий оборот МО'"));
	
	УстановитьГруппировкуКолонок(ДокументРезультат, НСтр("ru='Кредитовый оборот МУ';uk='Кредитовий оборот МО'"),Область);
	ДокументРезультат.ПоказатьУровеньГруппировокКолонок(0);
		
	//добавим заголовок
	ОбластьПриемник = ДокументРезультат.Область(1,,1);
	
	НомерСтроки = ДокументРезультат.ВысотаТаблицы + 10;
	ИсходнаяОбласть = ДокументРезультат.Область(НомерСтроки,,НомерСтроки);
	
	ДокументРезультат.ВставитьОбласть(ИсходнаяОбласть,ОбластьПриемник,ТипСмещенияТабличногоДокумента.ПоВертикали);
	ДокументРезультат.ВставитьОбласть(ИсходнаяОбласть,ОбластьПриемник,ТипСмещенияТабличногоДокумента.ПоВертикали);
	ДокументРезультат.ВставитьОбласть(ИсходнаяОбласть,ОбластьПриемник,ТипСмещенияТабличногоДокумента.ПоВертикали);
	ДокументРезультат.ФиксацияСверху = ДокументРезультат.ФиксацияСверху + 3;
	Если ВалютыНеСовпадают Тогда
		ДокументРезультат.ВставитьОбласть(ИсходнаяОбласть,ОбластьПриемник,ТипСмещенияТабличногоДокумента.ПоВертикали);
		ДокументРезультат.ФиксацияСверху = ДокументРезультат.ФиксацияСверху + 1;
	КонецЕсли;
	
	// Настроим вывод заголовка
	ЗаголовокОтчета = НСтр("ru='Сверка оборотов международного и регл. учетов';uk='Звірка оборотів міжнародного і регл. обліків'");
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("Заголовок");
	Если Параметр <> Неопределено Тогда
		ЗаголовокОтчета = Параметр.Значение;
	КонецЕсли;
	ОбластьЗаголовка = ДокументРезультат.Область(2,1);
	ОбластьЗаголовка.Текст = ЗаголовокОтчета;
	ОбластьЗаголовка.Шрифт = Новый Шрифт(ОбластьЗаголовка.Шрифт,,18,Истина);
	
	Если ВалютыНеСовпадают Тогда
		ОбластьЗаголовка = ДокументРезультат.Область(3,1);
		ОбластьЗаголовка.Текст = 
			НСтр("ru='Внимание! Функциональная валюта международного учета не совпадает с валютой регламентированного учета!';uk='Увага! Функціональна валюта міжнародного обліку не збігається з валютою регламентованого обліку!'");
		ОбластьЗаголовка.Шрифт = Новый Шрифт(ОбластьЗаголовка.Шрифт,,12,);
		ОбластьЗаголовка.ЦветТекста = Новый Цвет(255,0,0);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьГруппировкуКолонок(ДокументРезультат, ИмяГруппы, НачальнаяОбласть = Неопределено)
	
	Область = ДокументРезультат.НайтиТекст("Обычная",НачальнаяОбласть);
	ШаблонТекста = "C%1:C%2";
	Адрес = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Строка(Область.Лево), Строка(Область.Лево+4));
	СгруппироватьКолонки(ДокументРезультат, Адрес, ИмяГруппы);
	
КонецПроцедуры

Процедура СгруппироватьКолонки(ДокументРезультат, АдресКолонок, ИмяГруппы = "")
	
	Область = ДокументРезультат.Область(АдресКолонок);
	Область.Сгруппировать(ИмяГруппы);
	
КонецПроцедуры

Процедура ПоказатьУровеньГруппировкиСтрок(ДокументРезультат, Уровень = 0)
	
	У = ДокументРезультат.КоличествоУровнейГруппировокСтрок() - 1;
	Пока У > Уровень Цикл
		ДокументРезультат.ПоказатьУровеньГруппировокСтрок(У);
		У = У - 1;
	КонецЦикла;
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(Уровень);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
