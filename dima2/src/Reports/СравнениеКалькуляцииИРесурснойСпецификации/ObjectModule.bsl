#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем Организация, Спецификация, ВидЦены, Валюта, Период, КэшированныеЗначения;

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
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Спецификация", Параметры.ПараметрКоманды);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Подготовим и выведем отчет.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	НаборДанных = РезультатСравнения();
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиКомпоновкиДанных,
		ДанныеРасшифровки);
		
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	ВнешниеНаборыДанных = Новый Структура("НаборДанных", НаборДанных);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	ПараметрОрганизация = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Организация");
	Если ПараметрОрганизация <> Неопределено Тогда
		Если ПараметрОрганизация.Использование Тогда
			Организация = ПараметрОрганизация.Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Организация = Неопределено Тогда
		СтрокаСообщения = НСтр("ru='Не установлено значение параметра ""Организация"".';uk='Не встановлено параметр ""Організація"".'");
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	ПараметрСпецификация = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Спецификация");
	Спецификация = ПараметрСпецификация.Значение;
	
	ПараметрДатаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	Период = ?(ЗначениеЗаполнено(ПараметрДатаОтчета.Значение), КонецДня(ПараметрДатаОтчета.Значение), КонецДня(ТекущаяДатаСеанса()));
	
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	Если ПараметрВалюта.Значение <> Валюта Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Валюта", Валюта);
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатСравнения()
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДанныеСпецификацииВМенеджерВременныхТаблиц(МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =	Документы.ПлановаяКалькуляция.ТекстЗапросаДействующиеКалькуляции() +
					Документы.ПлановаяКалькуляция.ТекстЗапросаДанныеКалькуляцийИСпецификации() +
					Документы.ПлановаяКалькуляция.ТекстЗапросаДанныеДляРасчетаФормул();
	
	Результат = Запрос.ВыполнитьПакет();
	
	Индекс = Результат.ВГраница();
	
	СтатьиКалькуляции = Результат[Индекс].Выгрузить();
	СтатьиРасходов = Результат[Индекс-1].Выгрузить();
	
	ВыборкаКалькуляция = Результат[Индекс-2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ИтогПоСтатьямКалькуляции = Результат[Индекс-3].Выгрузить();
	
	ТаблицаСравнения = Результат[Индекс-6].Выгрузить();
	
	Документы.ПлановаяКалькуляция.ДополнитьНаборДанныхРассчитываемымиЗначениями(ТаблицаСравнения, ВыборкаКалькуляция, СтатьиКалькуляции, СтатьиРасходов, ИтогПоСтатьямКалькуляции);
	
	Возврат ТаблицаСравнения;
	
КонецФункции

Процедура ДанныеСпецификацииВМенеджерВременныхТаблиц(МенеджерВременныхТаблиц)
	
	ДанныеПоНоменклатуре = Справочники.РесурсныеСпецификации.ДанныеОсновногоИзделияСпецификации(Спецификация);
	ТабличныеЧасти = Справочники.РесурсныеСпецификации.ДанныеСпецификацииСПолуфабрикатами(ДанныеПоНоменклатуре, Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВыходныеИзделия", ТабличныеЧасти.ВыходныеИзделия);
	Запрос.УстановитьПараметр("ВозвратныеОтходы", ТабличныеЧасти.ВозвратныеОтходы);
	Запрос.УстановитьПараметр("МатериалыИУслуги", ТабличныеЧасти.МатериалыИУслуги);
	Запрос.УстановитьПараметр("Трудозатраты", ТабличныеЧасти.Трудозатраты);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Период", Период);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Документ.ЗаказНаПроизводство.ПустаяСсылка) КАК ЗаказНаПроизводство,
	|	0 КАК КодСтрокиЗаказаНаПроизводство,
	|	&Спецификация КАК Спецификация,
	|	ВыходныеИзделия.НомерСтроки КАК НомерСтроки,
	|	ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ВыходныеИзделия.Характеристика КАК Характеристика,
	|	ВыходныеИзделия.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВыходныеИзделия.ДоляСтоимости КАК ДоляСтоимости,
	|	&Организация КАК Организация,
	|	&Период КАК ДатаПотребности,
	|	&Период КАК НачатьНеРанее,
	|	ВыходныеИзделия.Количество КАК КоличествоПоЗаказу,
	|	ВыходныеИзделия.Количество КАК КоличествоПоСпецификации
	|ПОМЕСТИТЬ СпецификацияВыходныеИзделия
	|ИЗ
	|	&ВыходныеИзделия КАК ВыходныеИзделия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МатериалыИУслуги.Номенклатура КАК Номенклатура,
	|	МатериалыИУслуги.Характеристика КАК Характеристика,
	|	МатериалыИУслуги.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	МатериалыИУслуги.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	МатериалыИУслуги.ПрименениеМатериала КАК Описание,
	|	МатериалыИУслуги.Количество КАК Количество,
	|	&Спецификация КАК Спецификация,
	|	ЗНАЧЕНИЕ(Документ.ЗаказНаПроизводство.ПустаяСсылка) КАК ЗаказНаПроизводство,
	|	0 КАК КодСтрокиЗаказаНаПроизводство,
	|	&Период КАК НачатьНеРанее
	|ПОМЕСТИТЬ ВТСпецификацияМатериалы
	|ИЗ
	|	&МатериалыИУслуги КАК МатериалыИУслуги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВозвратныеОтходы.Номенклатура КАК Номенклатура,
	|	ВозвратныеОтходы.Характеристика КАК Характеристика,
	|	ВозвратныеОтходы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВозвратныеОтходы.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ВозвратныеОтходы.ОписаниеИзделия КАК Описание,
	|	ВозвратныеОтходы.Количество КАК Количество,
	|	&Спецификация КАК Спецификация,
	|	ЗНАЧЕНИЕ(Документ.ЗаказНаПроизводство.ПустаяСсылка) КАК ЗаказНаПроизводство,
	|	0 КАК КодСтрокиЗаказаНаПроизводство,
	|	&Период КАК НачатьНеРанее
	|ПОМЕСТИТЬ ВТСпецификацияОтходы
	|ИЗ
	|	&ВозвратныеОтходы КАК ВозвратныеОтходы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Трудозатраты.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	Трудозатраты.ВидРабот КАК ВидРабот,
	|	Трудозатраты.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
	|	Трудозатраты.НазначениеРабот КАК Описание,
	|	Трудозатраты.Количество КАК Количество,
	|	&Спецификация КАК Спецификация,
	|	ЗНАЧЕНИЕ(Документ.ЗаказНаПроизводство.ПустаяСсылка) КАК ЗаказНаПроизводство,
	|	0 КАК КодСтрокиЗаказаНаПроизводство,
	|	&Период КАК НачатьНеРанее
	|ПОМЕСТИТЬ ВТСпецификацияТрудозатраты
	|ИЗ
	|	&Трудозатраты КАК Трудозатраты";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли

