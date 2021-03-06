#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ЗаказНаПроизводство;

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
	
	ПараметрЗаказНаПроизводство = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ЗаказНаПроизводство");
	ЗаказНаПроизводство = ПараметрЗаказНаПроизводство.Значение;
	
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
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ЗаказНаПроизводство", ЗаказНаПроизводство);
	
	Запрос.Текст =	Документы.ЗаказНаПроизводство.ТекстЗапросаПоТабличнымЧастямЗаказа() +
					Документы.ПлановаяКалькуляция.ТекстЗапросаДействующиеКалькуляции() +
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

#КонецОбласти 

#КонецЕсли

