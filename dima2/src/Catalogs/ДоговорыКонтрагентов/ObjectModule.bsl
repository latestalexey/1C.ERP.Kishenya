#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		
		ЗаполнитьНаОснованииПартнера(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СоглашенияСКлиентами")
	 ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СоглашенияСПоставщиками") Тогда
		
		ЗаполнитьНаОснованииСоглашения(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьПоОтбору(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьСправочник(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Дата начала действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала действия договора должна быть не меньше даты договора';uk='Дата початку дії договору повинна бути не менше дати договору'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты договора';uk='Дата закінчення дії договору повинна бути не менше дати договору'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты начала действия';uk='Дата закінчення дії договору повинна бути не менше дати початку дії'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	
	Если НЕ ЗначениеЗаполнено(Партнер) Тогда
		
		ТекстОшибки = НСтр("ru='Не заполнено поле ""%1""';uk='Не заповнене поле ""%1""'");
		ЗаголовокПартнер = ПартнерыИКонтрагенты.ЗаголовокРеквизитаПартнерВЗависимостиОтХозяйственнойОперации(ХозяйственнаяОперация);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЗаголовокПартнер);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект, 
			"Партнер",
			,
			Отказ);
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(НаименованиеДляПечати) Тогда
		НаименованиеДляПечати = СокрЛП(Наименование);
	КонецЕсли;
	
	ХозяйственнаяОперация = Справочники.ДоговорыКонтрагентов.ХозяйственнаяОперация(ТипДоговора);
	
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован);
	Если ЗначениеЗаполнено(ДопустимаяСуммаЗадолженности) И НЕ ОграничиватьСуммуЗадолженности Тогда
		ДопустимаяСуммаЗадолженности = 0;
	КонецЕсли;
	
	
	Если Не ЗаданГрафикИсполнения И ЗначениеЗаполнено(ГрафикИсполненияДоговора) Тогда
		Попытка
			ЗаблокироватьДанныеДляРедактирования(ГрафикИсполненияДоговора);
			ГрафикИсполненияДоговора.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
			ГрафикИсполненияДоговора = Неопределено;
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				Ссылка,
				,
				,
				Отказ);
		КонецПопытки;
	КонецЕсли;
	
    Если Не Справочники.ДоговорыКонтрагентов.ИспользоватьНоменклатуруЗаполненияНалоговыхНаАванс(ЭтотОбъект) Тогда
		НоменклатураЗаполненияНалоговыхНаАванс = Неопределено;
	КонецЕсли;
	
	// Если для данного типа договора МоментОпределенияБазыНДС в договоре не используется, очищаем реквизит
	Если Справочники.ДоговорыКонтрагентов.ПолучитьМоментОпределенияБазыНДСПоУмолчанию(ЭтотОбъект) = Неопределено Тогда
		МоментОпределенияБазыНДС = Неопределено;
	КонецЕсли;
	
	
	// Отработка смены пометки удаления
	Если Не ЭтоНовый() И ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		Справочники.КлючиАналитикиУчетаПоПартнерам.УстановитьПометкуУдаления(Новый Структура("Договор", Ссылка), ПометкаУдаления);
		Справочники.ВидыЗапасов.УстановитьПометкуУдаления(Новый Структура("Договор", Ссылка), ПометкаУдаления);
		Документы.ГрафикИсполненияДоговора.УстановитьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован               = Ложь;
	ДатаНачалаДействия       = '00010101';
	ДатаОкончанияДействия    = '00010101';
	ИдентификаторПлатежа     = Неопределено;
	ГрафикИсполненияДоговора = Неопределено;
	ИнициализироватьСправочник(, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииПартнера(Знач Партнер, ДанныеЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("Партнер", Партнер);
	ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер));
	ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(Партнер));
	ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперацияПоПартнеру(Партнер));
	ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСоглашения(Знач Соглашение, ДанныеЗаполнения)

	ПолноеИмяСправочника = Соглашение.Метаданные().ПолноеИмя();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&ТекущаяДата КАК Дата,
	|	ДанныеСоглашения.Партнер			   КАК Партнер,
	|	ДанныеСоглашения.Контрагент			   КАК Контрагент,
	|	ДанныеСоглашения.Организация		   КАК Организация,
	|	ДанныеСоглашения.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеСоглашения.Валюта				   КАК ВалютаВзаиморасчетов,
	|	ДанныеСоглашения.ПорядокОплаты		   КАК ПорядокОплаты,
	|	//ТекстКонтактноеЛицо
	|
	|	ВЫБОР КОГДА ДанныеСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
	|	 ИЛИ ДанныеСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует) ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК ЕстьОшибкиСтатус,
	|
	|	НЕ ДанныеСоглашения.ИспользуютсяДоговорыКонтрагентов КАК ЕстьОшибкиИспользованиеДоговоров,
	|	ДанныеСоглашения.НаправлениеДеятельности КАК НаправлениеДеятельности
	|
	|ИЗ
	|	" + ПолноеИмяСправочника + " КАК ДанныеСоглашения
	|ГДЕ
	|	ДанныеСоглашения.Ссылка = &Ссылка
	|");
	
	Если ПолноеИмяСправочника = "Справочник.СоглашенияСКлиентами" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//ТекстКонтактноеЛицо", "ДанныеСоглашения.КонтактноеЛицо        КАК КонтактноеЛицо,");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеЗаполнения = Новый Структура;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		ПроверитьВозможностьВводаНаОснованииСоглашения(Выборка.ЕстьОшибкиИспользованиеДоговоров, Выборка.ЕстьОшибкиСтатус);
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Партнер) 
			И Не ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			ДанныеЗаполнения.Контрагент = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер);
			
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(Выборка.ХозяйственнаяОперация));
		
		ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения);
		ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("ПартнерПоУмолчанию") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ДанныеЗаполнения.ПартнерПоУмолчанию);
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
		
	ИначеЕсли ДанныеЗаполнения.Свойство("Контрагент") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Контрагент, "Партнер"));
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		Если НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
			ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
		Если НЕ (ДанныеЗаполнения.Свойство("КонтактноеЛицо") И ЗначениеЗаполнено(ДанныеЗаполнения.КонтактноеЛицо)) Тогда
			ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
	КонецЕсли;;
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения);
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперацияПоУмолчанию") Тогда
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ДанныеЗаполнения.ХозяйственнаяОперацияПоУмолчанию);
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") И ЗначениеЗаполнено(ДанныеЗаполнения.Партнер) Тогда
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперацияПоПартнеру(ДанныеЗаполнения.Партнер));
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") И Не ДанныеЗаполнения.Свойство("ПорядокОплаты") Тогда
		ДанныеЗаполнения.Вставить("ПорядокОплаты",
			Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ДанныеЗаполнения.ВалютаВзаиморасчетов));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВозможностьВводаНаОснованииСоглашения(ЕстьОшибкиИспользованиеДоговоров, ЕстьОшибкиСтатус)
	
	Если ЕстьОшибкиИспользованиеДоговоров Тогда
		
		ТекстОшибки = НСтр("ru='По соглашению не требуется указание договоров. Ввод на основании запрещен.';uk='За офертою не потрібно зазначення договорів. Введення на підставі заборонене.'");
	
		ВызватьИсключение ТекстОшибки;
		
	ИначеЕсли ЕстьОшибкиСтатус Тогда
		
		ТекстОшибки = НСтр("ru='Ввод на основании недействующего соглашения запрещен.';uk='Введення на підставі недіючої оферти заборонене.'");
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчет") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчет)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Организация") И ЗначениеЗаполнено(ДанныеЗаполнения.Организация)) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ДанныеЗаполнения.Свойство("ПорядокОплаты") И ДанныеЗаполнения.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И ((БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаОрганизаций.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Организация", ДанныеЗаполнения.Организация);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчет", Выборка.БанковскийСчет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчетКонтрагента") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчетКонтрагента)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ДанныеЗаполнения.Свойство("ПорядокОплаты") И ДанныеЗаполнения.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаКонтрагентов.Ссылка КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|ГДЕ
	|	БанковскиеСчетаКонтрагентов.Владелец = &Контрагент
	|	И ((БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаКонтрагентов.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Контрагент", ДанныеЗаполнения.Контрагент);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчетКонтрагента", Выборка.БанковскийСчетКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет реквизиты справочника значениями "по умолчанию".
//
Процедура ИнициализироватьСправочник(ДанныеЗаполнения = Неопределено, ЗаполнятьВсеРеквизиты = Истина) Экспорт
	
	Менеджер = Пользователи.ТекущийПользователь();
	Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует;
	
	Если ЗаполнятьВсеРеквизиты Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") Тогда
			ВалютаВзаиморасчетов = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ПорядокОплаты") Тогда
			ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов);
		КонецЕсли;
		
		ТипДоговора = Справочники.ДоговорыКонтрагентов.ТипДоговора(ХозяйственнаяОперация);
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация = Организация;
		СтруктураПараметров.БанковскийСчет = БанковскийСчет;
		ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
		Справочники.ДоговорыКонтрагентов.ЗаполнитьРеквизитыНалоговыхДокументов(ЭтотОбъект);	
		
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ХозяйственнаяОперацияПоПартнеру(Партнер)
	
	ДанныеПартнера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Партнер, "Клиент, Поставщик");
	
	Если ДанныеПартнера.Клиент И НЕ ДанныеПартнера.Поставщик Тогда
		Возврат Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	ИначеЕсли ДанныеПартнера.Поставщик И НЕ ДанныеПартнера.Клиент Тогда
		Возврат Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Иначе
		Возврат Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	КонецЕсли; 
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
