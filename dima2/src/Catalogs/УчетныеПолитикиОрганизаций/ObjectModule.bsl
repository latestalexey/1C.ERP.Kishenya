
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ФормироватьРезервОтпусковБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияРезерваОтпусков");
	КонецЕсли;
	
	//++ НЕ УТ
	Если (ФормироватьРезервОтпусковБУ И МетодНачисленияРезерваОтпусков <> Перечисления.МетодыНачисленияРезервовОтпусков.НормативныйМетод Или
		Не ФормироватьРезервОтпусковБУ) Тогда
	//-- НЕ УТ
		МассивНепроверяемыхРеквизитов.Добавить("НормативОтчисленийВРезервОтпусков");
		МассивНепроверяемыхРеквизитов.Добавить("ПредельнаяВеличинаОтчисленийВРезервОтпусков");
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда 
	//-- НЕ УТ
		МассивНепроверяемыхРеквизитов.Добавить("ИспользуемыеКлассыСчетовРасходов");
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ		

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//++ НЕ УТ
	
	// Запись настроек в регистр УчетнаяПолитикаОрганизаций
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизаций.Организация КАК Организация,
	|	УчетнаяПолитикаОрганизаций.Организация.ЮрФизЛицо КАК ЮрФизЛицо,
	|	УчетнаяПолитикаОрганизаций.ИННПлательщикаНДС КАК ИННПлательщикаНДС,
	|	УчетнаяПолитикаОрганизаций.НомерСвидетельстваПлательщикаНДС КАК НомерСвидетельстваПлательщикаНДС,
	|	УчетнаяПолитикаОрганизаций.Период КАК Период
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних КАК УчетнаяПолитикаОрганизаций
	|ГДЕ
	|	УчетнаяПолитикаОрганизаций.УчетнаяПолитика = &УчетнаяПолитика";
	
	Запрос.УстановитьПараметр("УчетнаяПолитика", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Набор = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СоздатьНаборЗаписей();
		Набор.Отбор.Организация.Установить(Выборка.Организация);
		Набор.Отбор.Период.Установить(НачалоГода(Выборка.Период));
		
		СтрокаНабора = Набор.Добавить();
		СтрокаНабора.Организация             = Выборка.Организация;
		СтрокаНабора.Период                  = НачалоГода(Выборка.Период);
		
		// настройки резервов
		ЗаполнитьЗначенияСвойств(СтрокаНабора, ЭтотОбъект,
			"ФормироватьРезервОтпусковБУ, МетодНачисленияРезерваОтпусков, НормативОтчисленийВРезервОтпусков, ПредельнаяВеличинаОтчисленийВРезервОтпусков");
		
		Набор.Записать(Истина);
		
		Набор = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьНаборЗаписей();
		Набор.Отбор.Организация.Установить(Выборка.Организация);
		Набор.Отбор.Период.Установить(Выборка.Период);
		
		СтрокаНабора = Набор.Добавить();
		СтрокаНабора.Организация             = Выборка.Организация;
		СтрокаНабора.Период                  = Выборка.Период;
		СтрокаНабора.УчетнаяПолитика         = ЭтотОбъект.Ссылка;
		
		// прочие параметры учетной политики
		ПлательщикНалогаНаПрибыль = (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.НалогНаПрибыльИНДС) ИЛИ (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.НалогНаПрибыль);
		ПлательщикНДС             = (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.НалогНаПрибыльИНДС) ИЛИ (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ЕдиныйНалогИНДС);
		ПлательщикЕН              = (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ЕдиныйНалог) ИЛИ (ЭтотОбъект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ЕдиныйНалогИНДС);
		
		СтрокаНабора.ПлательщикНалогаНаПрибыль = ПлательщикНалогаНаПрибыль;
		СтрокаНабора.ПлательщикНДС             = ПлательщикНДС;
		СтрокаНабора.ПлательщикЕН              = ПлательщикЕН;
		
		СтрокаНабора.ИННПлательщикаНДС                    = Выборка.ИННПлательщикаНДС;
		СтрокаНабора.НомерСвидетельстваПлательщикаНДС     = Выборка.НомерСвидетельстваПлательщикаНДС;
		
		
		Набор.Записать(Истина);
	КонецЦикла;
	
	
	//-- НЕ УТ
	Возврат; // Чтобы в УТ и КА обработчик был не пустым.
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

