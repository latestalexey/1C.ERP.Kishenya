#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет сравнение нескольких ресурсных спецификаций.
//
// Параметры:
//  СписокСпецификаций - Список значений - список сравниваемых спецификаций.
//
// Возвращаемое значение:
//  Структура - структура результата сравнения.
//
Функция ВыполнитьСравнениеСпецификаций(СписокСпецификаций) Экспорт
	
	ДанныеСравнения = Новый Структура;
	ДанныеСравнения.Вставить("СписокЭтапов",    Новый СписокЗначений);
	ДанныеСравнения.Вставить("ДанныеСравнения", Новый Соответствие);
	
	ПолучитьДанныеСпецификаций(ДанныеСравнения, СписокСпецификаций);
	
	ОтметитьОтличия(ДанныеСравнения, СписокСпецификаций.Количество());
	
	Возврат ДанныеСравнения;
	
КонецФункции

// Выполняет сравнение изделия заказа на производство и ресурсной спецификации.
//
// Параметры:
//  ДанныеЗаказа			- Структура - данные изделия, для которого происходит поиск спецификации для сравнения.
//  Этапы					- Таблица значений - информация об этапах заказа на производство.
//  МатериалыИУслуги		- Таблица значений -  информация об материалах заказа на производство.
//  ВыходныеИзделия			- Таблица значений -  информация об выходных изделиях заказа на производство.
//  ТаблицаВидыРЦ			- Таблица значений -  информация о видах рабочих центров.
//
// Возвращаемое значение:
//  Структура - структура результата сравнения.
//
Функция ВыполнитьСравнениеЗаказаСоСпецификациями(ДанныеЗаказа, Этапы, МатериалыИУслуги, ВыходныеИзделия, ВозвратныеОтходы, ТаблицаВидыРЦ) Экспорт
	
	ДанныеСравнения = Новый Структура;
	ДанныеСравнения.Вставить("СписокЭтапов",    Новый СписокЗначений);
	ДанныеСравнения.Вставить("ДанныеСравнения", Новый Соответствие);
	
	СтрокиЭтапы = Этапы.НайтиСтроки(Новый Структура("КлючСвязиПродукция", ДанныеЗаказа.КлючСвязиПродукция));
	Для каждого ВыборкаЭтапов из СтрокиЭтапы Цикл
		
		ОбъектСравнения = НСтр("ru='По заказу';uk='По замовленню'");
		
		КлючЭтапа = Строка(ВыборкаЭтапов.КлючЭтапа);
		ВыборкаЭтапов.КлючЭтапа = КлючЭтапа;
		
		ПолеЗначения = "Значение1";
		
		СтрокаЭтап = ДанныеСравнения.СписокЭтапов.НайтиПоЗначению(КлючЭтапа);
		Если СтрокаЭтап = Неопределено Тогда
			ПредставлениеЭтапа = Строка(ВыборкаЭтапов.Этап) + " (" + ВыборкаЭтапов.СпецификацияПредставление + ")";
			ДанныеСравнения.СписокЭтапов.Добавить(КлючЭтапа, ПредставлениеЭтапа);
			
			ДанныеСравненияЭтапа = ПолучитьСтруктуруДанныхСравнения();
			
			ДанныеСравнения.ДанныеСравнения.Вставить(КлючЭтапа, ДанныеСравненияЭтапа);
			
			ДанныеСравненияЭтапа.СписокСпецификаций = Новый Массив;
		Иначе
			ДанныеСравненияЭтапа = ДанныеСравнения.ДанныеСравнения.Получить(КлючЭтапа);
		КонецЕсли; 
		
		ДанныеСравненияЭтапа.СписокСпецификаций.Добавить(ОбъектСравнения);
		
		ДобавитьСвойстваЭтапа(ВыборкаЭтапов, ДанныеСравненияЭтапа.ТаблицаСвойств, ПолеЗначения);
		
		// ВыходныеИзделия
		СтрокиВыходныеИзделия = ВыходныеИзделия.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаЭтапов.КлючСвязи));
		ДобавитьДанныеПоНоменклатуре(СтрокиВыходныеИзделия, ДанныеСравненияЭтапа.ТаблицаИзделий, ПолеЗначения);
		
		// ВозвратныеОтходы
		СтрокиВозвратныеОтходы = ВозвратныеОтходы.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаЭтапов.КлючСвязи));
		ДобавитьДанныеПоНоменклатуре(СтрокиВозвратныеОтходы, ДанныеСравненияЭтапа.ТаблицаОтходов, ПолеЗначения);
		
		// МатериалыИУслуги
		СтрокиМатериалыИУслуги = МатериалыИУслуги.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаЭтапов.КлючСвязи));
		ДобавитьДанныеПоНоменклатуре(СтрокиМатериалыИУслуги, ДанныеСравненияЭтапа.ТаблицаМатериалов, ПолеЗначения);
		
		//++ НЕ УТКА
		
		// ВидыРабочихЦентров
		ДанныеТЧ = ТаблицаВидыРЦ.НайтиСтроки(Новый Структура("КлючСвязиЭтапы", ВыборкаЭтапов.КлючСвязи));
		ДобавитьДанныеПоВидамРЦ(ДанныеТЧ, ДанныеСравненияЭтапа.ТаблицаВидыРЦ, ПолеЗначения);
		
		//-- НЕ УТКА
		
	КонецЦикла;
	
	// Добавим данные по спецификации
	СтруктураДанных = Справочники.РесурсныеСпецификации.ДанныеСпецификацииСПолуфабрикатами(ДанныеЗаказа, Ложь, Истина);
	
	СтруктураДанных.Этапы.Колонки.Добавить("КлючЭтапа", Новый ОписаниеТипов("Строка"));
	СтруктураДанных.Этапы.Колонки.Добавить("СпецификацияПредставление", Новый ОписаниеТипов("Строка"));
	СтруктураДанных.МатериалыИУслуги.Колонки.Добавить("КлючЭтапа", Новый ОписаниеТипов("Строка"));
	СтруктураДанных.ВыходныеИзделия.Колонки.Добавить("КлючЭтапа", Новый ОписаниеТипов("Строка"));
	СтруктураДанных.ВозвратныеОтходы.Колонки.Добавить("КлючЭтапа", Новый ОписаниеТипов("Строка"));
	//++ НЕ УТКА
	СтруктураДанных.ВидыРабочихЦентров.Колонки.Добавить("КлючЭтапа", Новый ОписаниеТипов("Строка"));
	//-- НЕ УТКА
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Этапы.Этап КАК Этап
	|ПОМЕСТИТЬ ВТЭтапы
	|ИЗ
	|	&Этапы КАК Этапы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТЭтапы.Этап КАК Этап,
	|	ВТЭтапы.Этап.Владелец.Представление КАК СпецификацияПредставление,
	|	ВТЭтапы.Этап.Владелец.Код КАК КодСпецификации
	|ИЗ
	|	ВТЭтапы КАК ВТЭтапы");
	
	Запрос.УстановитьПараметр("Этапы", СтруктураДанных.Этапы);
	ДанныеЭтапов = Запрос.Выполнить().Выбрать();
	СтруктураОтбора = Новый Структура("Этап");
	
	Для каждого ЭлКоллекции Из СтруктураДанных.Этапы Цикл
		
		СтруктураОтбора.Этап = ЭлКоллекции.Этап;
		ДанныеЭтапов.НайтиСледующий(СтруктураОтбора);
		ЭлКоллекции.КлючЭтапа = Строка(ЭлКоллекции.Этап.УникальныйИдентификатор())+ "_" + ДанныеЭтапов.КодСпецификации;
		ЭлКоллекции.СпецификацияПредставление = ДанныеЭтапов.СпецификацияПредставление;
		ДанныеЭтапов.Сбросить();
		
	КонецЦикла;
	
	Для каждого ЭлКоллекции Из СтруктураДанных.МатериалыИУслуги Цикл
		СтруктураОтбора.Этап = ЭлКоллекции.Этап;
		ДанныеЭтапов.НайтиСледующий(СтруктураОтбора);
		ЭлКоллекции.КлючЭтапа = Строка(ЭлКоллекции.Этап.УникальныйИдентификатор())+ "_" + ДанныеЭтапов.КодСпецификации;
		ДанныеЭтапов.Сбросить();
	КонецЦикла;
	Для каждого ЭлКоллекции Из СтруктураДанных.ВыходныеИзделия Цикл
		СтруктураОтбора.Этап = ЭлКоллекции.Этап;
		ДанныеЭтапов.НайтиСледующий(СтруктураОтбора);
		ЭлКоллекции.КлючЭтапа = Строка(ЭлКоллекции.Этап.УникальныйИдентификатор())+ "_" + ДанныеЭтапов.КодСпецификации;
		ДанныеЭтапов.Сбросить();
	КонецЦикла;
	Для каждого ЭлКоллекции Из СтруктураДанных.ВозвратныеОтходы Цикл
		СтруктураОтбора.Этап = ЭлКоллекции.Этап;
		ДанныеЭтапов.НайтиСледующий(СтруктураОтбора);
		ЭлКоллекции.КлючЭтапа = Строка(ЭлКоллекции.Этап.УникальныйИдентификатор())+ "_" + ДанныеЭтапов.КодСпецификации;
		ДанныеЭтапов.Сбросить();
	КонецЦикла;
	//++ НЕ УТКА
	Для каждого ЭлКоллекции Из СтруктураДанных.ВидыРабочихЦентров Цикл
		СтруктураОтбора.Этап = ЭлКоллекции.Этап;
		ДанныеЭтапов.НайтиСледующий(СтруктураОтбора);
		ЭлКоллекции.КлючЭтапа = Строка(ЭлКоллекции.Этап.УникальныйИдентификатор())+ "_" + ДанныеЭтапов.КодСпецификации;
		ДанныеЭтапов.Сбросить();
	КонецЦикла;
	//-- НЕ УТКА
	Для каждого ВыборкаЭтапов из СтруктураДанных.Этапы Цикл
		
		ОбъектСравнения = ДанныеЗаказа.Спецификация;
		
		КлючЭтапа = Строка(ВыборкаЭтапов.КлючЭтапа);
		ВыборкаЭтапов.КлючЭтапа = КлючЭтапа;
		
		ПолеЗначения = "Значение";
		
		СтрокаЭтап = ДанныеСравнения.СписокЭтапов.НайтиПоЗначению(КлючЭтапа);
		Если СтрокаЭтап = Неопределено Тогда
			
			ПредставлениеЭтапа = Строка(ВыборкаЭтапов.Этап) + " (" + ВыборкаЭтапов.СпецификацияПредставление + ")";
			ДанныеСравнения.СписокЭтапов.Добавить(КлючЭтапа, ПредставлениеЭтапа);
			
			ДанныеСравненияЭтапа = ПолучитьСтруктуруДанныхСравнения();
			
			ДанныеСравнения.ДанныеСравнения.Вставить(КлючЭтапа, ДанныеСравненияЭтапа);
			
			ДанныеСравненияЭтапа.СписокСпецификаций = Новый Массив;
		Иначе
			ДанныеСравненияЭтапа = ДанныеСравнения.ДанныеСравнения.Получить(КлючЭтапа);
		КонецЕсли; 
		
		ДанныеСравненияЭтапа.СписокСпецификаций.Добавить(ОбъектСравнения);
		
		ДобавитьСвойстваЭтапа(ВыборкаЭтапов, ДанныеСравненияЭтапа.ТаблицаСвойств, ПолеЗначения);
		
		// ВыходныеИзделия
		СтрокиВыходныеИзделия = СтруктураДанных.ВыходныеИзделия.НайтиСтроки(Новый Структура("КлючЭтапа", ВыборкаЭтапов.КлючЭтапа));
		ДобавитьДанныеПоНоменклатуре(СтрокиВыходныеИзделия, ДанныеСравненияЭтапа.ТаблицаИзделий, ПолеЗначения);
		
		// ВозвратныеОтходы
		СтрокиВозвратныеОтходы = СтруктураДанных.ВозвратныеОтходы.НайтиСтроки(Новый Структура("КлючЭтапа", ВыборкаЭтапов.КлючЭтапа));
		ДобавитьДанныеПоНоменклатуре(СтрокиВозвратныеОтходы, ДанныеСравненияЭтапа.ТаблицаОтходов, ПолеЗначения);
		
		// МатериалыИУслуги
		СтрокиМатериалыИУслуги = СтруктураДанных.МатериалыИУслуги.НайтиСтроки(Новый Структура("КлючЭтапа", ВыборкаЭтапов.КлючЭтапа));
		ДобавитьДанныеПоНоменклатуре(СтрокиМатериалыИУслуги, ДанныеСравненияЭтапа.ТаблицаМатериалов, ПолеЗначения);
		
		//++ НЕ УТКА
		
		// ВидыРабочихЦентров
		СтрокиВидыРЦ = СтруктураДанных.ВидыРабочихЦентров.НайтиСтроки(Новый Структура("КлючЭтапа", ВыборкаЭтапов.КлючЭтапа));
		ДобавитьДанныеПоВидамРЦ(СтрокиВидыРЦ, ДанныеСравненияЭтапа.ТаблицаВидыРЦ, ПолеЗначения);
		
		//-- НЕ УТКА
		
	КонецЦикла;
	
	ОтметитьОтличия(ДанныеСравнения, 2);
	
	Возврат ДанныеСравнения;
	
КонецФункции

// Настраивает макет для отчета о сравнении спецификаций.
//
// Параметры:
//  РезультатСравнения - Табличный документ - для вывода результата сравнения.
//  ЕстьОтличия - Булево - флаг наличия отличий.
//
Процедура ЗавершитьВыводОтчета(РезультатСравнения, ЕстьОтличия) Экспорт
	
	Если ЕстьОтличия Тогда
		Возврат;
	КонецЕсли;
	
	МакетОтчета = Обработки.СравнениеСпецификаций.ПолучитьМакет("Макет");
	
	ОбластьСтрокаНетОтличий = МакетОтчета.ПолучитьОбласть("СтрокаНетОтличий");
	
	РезультатСравнения.Вывести(ОбластьСтрокаНетОтличий);
	
КонецПроцедуры

// Выводит результат сравнения в табличный документ.
//
// Параметры:
//  РезультатСравнения - Табличный документ - для вывода результата сравнения.
//  СписокСпецификаций - Список значений - список сравниваемых спецификаций.
//  ПоказатьТолькоОтличия - Булево - если Истина, то выводятся только отличия.
//  ДанныеСравнения - Структура - результат сравнения.
//  ЗаголовокОтчета - Строка - Заголовок отчета.
//  СтрокаЗаказа - Число - Строка заказа, если в сравнении присутствует заказ на производство.
//
// Возвращаемое значение:
//  Булево - Истина, если есть отличия.
//
Функция ВывестиОтчет(
		РезультатСравнения, 
		СписокСпецификаций, 
		ПоказатьТолькоОтличия, 
		ДанныеСравнения, 
		ЗаголовокОтчета = Неопределено, 
		СтрокаЗаказа = Неопределено) Экспорт
	
	Если ЗаголовокОтчета = Неопределено Тогда
		ЗаголовокОтчета = НСтр("ru='Сравнение спецификаций';uk='Порівняння специфікацій'");
	КонецЕсли;
	
	МакетОтчета = Обработки.СравнениеСпецификаций.ПолучитьМакет("Макет");
	
	// Заголовок отчета
	Если ЗаголовокОтчета <> Неопределено Тогда
		ОбластьЗаголовок = МакетОтчета.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ЗаголовокОтчета;
		РезультатСравнения.Вывести(ОбластьЗаголовок);
	КонецЕсли; 
	
	Если СтрокаЗаказа <> Неопределено Тогда
		
		Если ПоказатьТолькоОтличия Тогда
			ЕстьОтличия = Ложь;
			Для каждого ДанныеЭтапа Из ДанныеСравнения.СписокЭтапов Цикл
				
				ДанныеСравненияЭтапа = ДанныеСравнения.ДанныеСравнения.Получить(ДанныеЭтапа.Значение);
				
				Если ДанныеСравненияЭтапа.СписокСпецификаций.Количество() <> СписокСпецификаций.Количество() 
					ИЛИ ДанныеСравненияЭтапа.ТаблицаСвойств.Найти(Истина, "ЕстьОтличия") <> Неопределено 
					ИЛИ ДанныеСравненияЭтапа.ТаблицаИзделий.Найти(Истина, "ЕстьОтличия") <> Неопределено 
					ИЛИ ДанныеСравненияЭтапа.ТаблицаОтходов.Найти(Истина, "ЕстьОтличия") <> Неопределено 
					ИЛИ ДанныеСравненияЭтапа.ТаблицаМатериалов.Найти(Истина, "ЕстьОтличия") <> Неопределено
					//++ НЕ УТКА
					ИЛИ ДанныеСравненияЭтапа.ТаблицаВидыРЦ.Найти(Истина, "ЕстьОтличия") <> Неопределено 
					//-- НЕ УТКА
					Тогда
					
					ЕстьОтличия = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЕстьОтличия Тогда
				Возврат Ложь;
			КонецЕсли; 
		КонецЕсли;
		
		ОбластьСтрокаЗаказа = МакетОтчета.ПолучитьОбласть("СтрокаЗаказа");
		ОбластьСтрокаЗаказа.Параметры.СтрокаЗаказа = СтрокаЗаказа;
		РезультатСравнения.Вывести(ОбластьСтрокаЗаказа);
		РезультатСравнения.НачатьГруппуСтрок("СтрокаЗаказа");
	КонецЕсли;
	
	// Область "Шапка"
	ОбластьШапкаНазвание = МакетОтчета.ПолучитьОбласть("Шапка|НазванияСвойств");
	ОбластьШапкаИсточник = МакетОтчета.ПолучитьОбласть("Шапка|СвойстваИсточник");
	
	// Область "Этап"
	ОбластьЭтапНазвание = МакетОтчета.ПолучитьОбласть("Этап|НазванияСвойств");
	ОбластьЭтапИсточник = МакетОтчета.ПолучитьОбласть("Этап|СвойстваИсточник");
	
	// Область "ГруппаСвойств"
	ОбластьГруппаСвойствНазвание = МакетОтчета.ПолучитьОбласть("ГруппаСвойств|НазванияСвойств");
	ОбластьГруппаСвойствИсточник = МакетОтчета.ПолучитьОбласть("ГруппаСвойств|СвойстваИсточник");
	
	// Область "СвойстваСтрока"
	ОбластьСвойстваСтрокаНазвание = МакетОтчета.ПолучитьОбласть("СвойстваСтрока|НазванияСвойств");
	ОбластьСвойстваСтрокаИсточник = МакетОтчета.ПолучитьОбласть("СвойстваСтрока|СвойстваИсточник");
	
	//////////////////////////////////////
	// ВЫВОД ОТЧЕТА
	
	ШапкаВыведена = Ложь;
	
	ЕстьОтличия = Ложь;
	
	// Выведем данные этапов
	Для каждого ДанныеЭтапа Из ДанныеСравнения.СписокЭтапов Цикл
		
		ДанныеСравненияЭтапа = ДанныеСравнения.ДанныеСравнения.Получить(ДанныеЭтапа.Значение);
		
		// Этап не нужно выводить если:
		// - нужно показать только отличия
		// - у всех спецификаций есть этап
		// - нет различия в свойствах
		Если ПоказатьТолькоОтличия 
			И ДанныеСравненияЭтапа.СписокСпецификаций.Количество() = СписокСпецификаций.Количество() 
			И ДанныеСравненияЭтапа.ТаблицаСвойств.Найти(Истина, "ЕстьОтличия") = Неопределено 
			И ДанныеСравненияЭтапа.ТаблицаИзделий.Найти(Истина, "ЕстьОтличия") = Неопределено 
			И ДанныеСравненияЭтапа.ТаблицаОтходов.Найти(Истина, "ЕстьОтличия") = Неопределено 
			И ДанныеСравненияЭтапа.ТаблицаМатериалов.Найти(Истина, "ЕстьОтличия") = Неопределено 
			//++ НЕ УТКА
			И ДанныеСравненияЭтапа.ТаблицаВидыРЦ.Найти(Истина, "ЕстьОтличия") = Неопределено 
			//-- НЕ УТКА
			Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ ШапкаВыведена Тогда
			// Выведем шапку отчета
			РезультатСравнения.Вывести(ОбластьШапкаНазвание);
			Для каждого ЭлКоллекции Из СписокСпецификаций Цикл
				ОбластьШапкаИсточник.Параметры.ИмяИсточника         = ЭлКоллекции.Представление;
				ОбластьШапкаИсточник.Параметры.РасшифровкаИсточника = ЭлКоллекции.Значение;
				РезультатСравнения.Присоединить(ОбластьШапкаИсточник);
			КонецЦикла;
			
			ШапкаВыведена = Истина;
		КонецЕсли; 
		
		ЕстьОтличия = Истина;
		
		// Этап
		ОбластьЭтапНазвание.Параметры.Этап = ДанныеЭтапа.Представление;
		РезультатСравнения.Вывести(ОбластьЭтапНазвание, 2, "Этап");
		Для каждого ЭлКоллекции Из СписокСпецификаций Цикл
			ОбластьИсточник = РезультатСравнения.Присоединить(ОбластьЭтапИсточник);
			
			Если ДанныеСравненияЭтапа.СписокСпецификаций.Найти(ЭлКоллекции.Значение) = Неопределено Тогда
				ОбластьИсточник.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				ОбластьИсточник.Текст = НСтр("ru='<Отсутствует>';uk='<Відсутня>'");
			КонецЕсли;
		КонецЦикла;
		ОбластьИсточник.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
		
		Если ДанныеСравненияЭтапа.СписокСпецификаций.Количество() < 2 Тогда
			// Не выводим свойства, если этот этап только у одной спецификации
			Продолжить;
		КонецЕсли; 
		
		РезультатСравнения.НачатьГруппуСтрок("Этап");
		
		ВывестиГруппуСвойств(НСтр("ru='Свойства';uk='Властивості'"),
							ДанныеСравненияЭтапа.ТаблицаСвойств, 
							ОбластьГруппаСвойствНазвание, 
							ОбластьГруппаСвойствИсточник, 
							ОбластьСвойстваСтрокаНазвание, 
							ОбластьСвойстваСтрокаИсточник,
							РезультатСравнения,
							СписокСпецификаций,
							ПоказатьТолькоОтличия);
		
		ВывестиГруппуСвойств(НСтр("ru='Продукция';uk='Продукція'"),
							ДанныеСравненияЭтапа.ТаблицаИзделий, 
							ОбластьГруппаСвойствНазвание, 
							ОбластьГруппаСвойствИсточник, 
							ОбластьСвойстваСтрокаНазвание, 
							ОбластьСвойстваСтрокаИсточник,
							РезультатСравнения,
							СписокСпецификаций,
							ПоказатьТолькоОтличия);
							
		ВывестиГруппуСвойств(НСтр("ru='Возвратные отходы';uk='Зворотні відходи'"),
							ДанныеСравненияЭтапа.ТаблицаОтходов, 
							ОбластьГруппаСвойствНазвание, 
							ОбластьГруппаСвойствИсточник, 
							ОбластьСвойстваСтрокаНазвание, 
							ОбластьСвойстваСтрокаИсточник,
							РезультатСравнения,
							СписокСпецификаций,
							ПоказатьТолькоОтличия);
		
		ВывестиГруппуСвойств(НСтр("ru='Материалы';uk='Матеріали'"),
							ДанныеСравненияЭтапа.ТаблицаМатериалов, 
							ОбластьГруппаСвойствНазвание, 
							ОбластьГруппаСвойствИсточник, 
							ОбластьСвойстваСтрокаНазвание, 
							ОбластьСвойстваСтрокаИсточник,
							РезультатСравнения,
							СписокСпецификаций,
							ПоказатьТолькоОтличия);
		//++ НЕ УТКА
		ВывестиГруппуСвойств(НСтр("ru='Виды рабочих центров';uk='Види робочих центрів'"),
							ДанныеСравненияЭтапа.ТаблицаВидыРЦ, 
							ОбластьГруппаСвойствНазвание, 
							ОбластьГруппаСвойствИсточник, 
							ОбластьСвойстваСтрокаНазвание, 
							ОбластьСвойстваСтрокаИсточник,
							РезультатСравнения,
							СписокСпецификаций,
							ПоказатьТолькоОтличия);
		//-- НЕ УТКА
		
		РезультатСравнения.ЗакончитьГруппуСтрок();
	КонецЦикла; 
	
	Если СтрокаЗаказа <> Неопределено Тогда
		РезультатСравнения.ЗакончитьГруппуСтрок();
	КонецЕсли;
	
	Возврат ЕстьОтличия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтметитьОтличия(ДанныеСравнения, КоличествоИсточников)
	
	Для каждого ЭлДанныеСравненияЭтапа Из ДанныеСравнения.ДанныеСравнения Цикл
		
		ДанныеСравненияЭтапа = ЭлДанныеСравненияЭтапа.Значение;
		
		Для каждого ДанныеСвойства Из ДанныеСравненияЭтапа.ТаблицаСвойств Цикл
			Для каждого элЗначение1 Из ДанныеСвойства.Значения Цикл
				Для каждого элЗначение2 Из ДанныеСвойства.Значения Цикл
					Если элЗначение1.Значение <> элЗначение2.Значение Тогда
						ДанныеСвойства.ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ДанныеСвойства.ЕстьОтличия Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого ДанныеСвойства Из ДанныеСравненияЭтапа.ТаблицаМатериалов Цикл
			Если ДанныеСвойства.Значения.Количество() <> КоличествоИсточников Тогда
				ДанныеСвойства.ЕстьОтличия = Истина;
				Продолжить;
			КонецЕсли;
			
			Для каждого элЗначение1 Из ДанныеСвойства.Значения Цикл
				Для каждого элЗначение2 Из ДанныеСвойства.Значения Цикл
					Если элЗначение1.Значение <> элЗначение2.Значение Тогда
						ДанныеСвойства.ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ДанныеСвойства.ЕстьОтличия Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого ДанныеСвойства Из ДанныеСравненияЭтапа.ТаблицаИзделий Цикл
			Если ДанныеСвойства.Значения.Количество() <> КоличествоИсточников Тогда
				ДанныеСвойства.ЕстьОтличия = Истина;
				Продолжить;
			КонецЕсли;
			
			Для каждого элЗначение1 Из ДанныеСвойства.Значения Цикл
				Для каждого элЗначение2 Из ДанныеСвойства.Значения Цикл
					Если элЗначение1.Значение <> элЗначение2.Значение Тогда
						ДанныеСвойства.ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ДанныеСвойства.ЕстьОтличия Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого ДанныеСвойства Из ДанныеСравненияЭтапа.ТаблицаОтходов Цикл
			Если ДанныеСвойства.Значения.Количество() <> КоличествоИсточников Тогда
				ДанныеСвойства.ЕстьОтличия = Истина;
				Продолжить;
			КонецЕсли;
			
			Для каждого элЗначение1 Из ДанныеСвойства.Значения Цикл
				Для каждого элЗначение2 Из ДанныеСвойства.Значения Цикл
					Если элЗначение1.Значение <> элЗначение2.Значение Тогда
						ДанныеСвойства.ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ДанныеСвойства.ЕстьОтличия Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		//++ НЕ УТКА
		Для каждого ДанныеСвойства Из ДанныеСравненияЭтапа.ТаблицаВидыРЦ Цикл
			Если ДанныеСвойства.Значения.Количество() <> КоличествоИсточников Тогда
				ДанныеСвойства.ЕстьОтличия = Истина;
				Продолжить;
			КонецЕсли;
			
			Для каждого элЗначение1 Из ДанныеСвойства.Значения Цикл
				Для каждого элЗначение2 Из ДанныеСвойства.Значения Цикл
					Если элЗначение1.Значение <> элЗначение2.Значение Тогда
						ДанныеСвойства.ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ДанныеСвойства.ЕстьОтличия Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		//-- НЕ УТКА
	КонецЦикла; 
	
КонецПроцедуры

Функция ПолучитьСтруктуруДанныхСравнения()
	
	ТаблицаСвойств = Новый ТаблицаЗначений;
	ТаблицаСвойств.Колонки.Добавить("Свойство",    Новый ОписаниеТипов("Строка"));
	ТаблицаСвойств.Колонки.Добавить("Значения",    Новый ОписаниеТипов("Структура"));
	ТаблицаСвойств.Колонки.Добавить("ЕстьОтличия", Новый ОписаниеТипов("Булево"));
	
	ТаблицаМатериалов = Новый ТаблицаЗначений;
	ТаблицаМатериалов.Колонки.Добавить("Свойство",       Новый ОписаниеТипов("Строка"));
	ТаблицаМатериалов.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаМатериалов.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаМатериалов.Колонки.Добавить("Значения",       Новый ОписаниеТипов("Структура"));
	ТаблицаМатериалов.Колонки.Добавить("ЕстьОтличия",    Новый ОписаниеТипов("Булево"));
	
	ТаблицаИзделий = Новый ТаблицаЗначений;
	ТаблицаИзделий.Колонки.Добавить("Свойство",       Новый ОписаниеТипов("Строка"));
	ТаблицаИзделий.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаИзделий.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаИзделий.Колонки.Добавить("Значения",       Новый ОписаниеТипов("Структура"));
	ТаблицаИзделий.Колонки.Добавить("ЕстьОтличия",    Новый ОписаниеТипов("Булево"));
	
	ТаблицаОтходов = Новый ТаблицаЗначений;
	ТаблицаОтходов.Колонки.Добавить("Свойство",       Новый ОписаниеТипов("Строка"));
	ТаблицаОтходов.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОтходов.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаОтходов.Колонки.Добавить("Значения",       Новый ОписаниеТипов("Структура"));
	ТаблицаОтходов.Колонки.Добавить("ЕстьОтличия",    Новый ОписаниеТипов("Булево"));

	//++ НЕ УТКА
	ТаблицаВидыРЦ = Новый ТаблицаЗначений;
	ТаблицаВидыРЦ.Колонки.Добавить("Свойство",          Новый ОписаниеТипов("Строка"));
	ТаблицаВидыРЦ.Колонки.Добавить("ВидРабочегоЦентра", Новый ОписаниеТипов("СправочникСсылка.ВидыРабочихЦентров"));
	ТаблицаВидыРЦ.Колонки.Добавить("Значения",          Новый ОписаниеТипов("Структура"));
	ТаблицаВидыРЦ.Колонки.Добавить("ЕстьОтличия",       Новый ОписаниеТипов("Булево"));
	//-- НЕ УТКА
	
	ДанныеСравнения = Новый Структура;
	ДанныеСравнения.Вставить("СписокСпецификаций");
	ДанныеСравнения.Вставить("ТаблицаСвойств",    ТаблицаСвойств);
	ДанныеСравнения.Вставить("ТаблицаМатериалов", ТаблицаМатериалов);
	ДанныеСравнения.Вставить("ТаблицаИзделий",    ТаблицаИзделий);
	ДанныеСравнения.Вставить("ТаблицаОтходов",    ТаблицаОтходов);
	//++ НЕ УТКА
	ДанныеСравнения.Вставить("ТаблицаВидыРЦ",     ТаблицаВидыРЦ);
	//-- НЕ УТКА
	
	Возврат ДанныеСравнения;
	
КонецФункции

Функция ДобавитьСвойство(ИмяСвойства, Значение, ТаблицаСвойств, ПолеЗначения)
	
	НайденныеСтроки = ТаблицаСвойств.НайтиСтроки(Новый Структура("Свойство", ИмяСвойства));
	Если НайденныеСтроки.Количество() = 0 Тогда
		СтрокаСвойства = ТаблицаСвойств.Добавить();
		СтрокаСвойства.Свойство = ИмяСвойства;
		СтрокаСвойства.Значения = Новый Структура;
	Иначе
		СтрокаСвойства = НайденныеСтроки[0];
	КонецЕсли;
	
	СтрокаСвойства.Значения.Вставить(ПолеЗначения, Значение);
	
	Возврат СтрокаСвойства;
	
КонецФункции

Процедура ДобавитьСвойстваЭтапа(ДанныеЭтапа, ТаблицаСвойств, ПолеЗначения)
	
	// Свойства
	ДобавитьСвойство(НСтр("ru='N этапа';uk='N етапу'"),       ДанныеЭтапа.НомерЭтапа,                 ТаблицаСвойств, ПолеЗначения);
	ДобавитьСвойство(НСтр("ru='N след. этапа';uk='N наст. етапу'"), ДанныеЭтапа.НомерСледующегоЭтапа,       ТаблицаСвойств, ПолеЗначения);
	ДобавитьСвойство(НСтр("ru='Подразделение';uk='Підрозділ'"), ДанныеЭтапа.ПодразделениеПредставление, ТаблицаСвойств, ПолеЗначения);
	
	ДобавитьСвойство(НСтр("ru='Одновременно производимое количество единиц/партий изделий';uk='Одночасно вироблена кількість одиниць/партій виробів'"), ДанныеЭтапа.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий, ТаблицаСвойств, ПолеЗначения);
	
	//++ НЕ УТКА
	ДобавитьСвойство(НСтр("ru='Маршрутная карта';uk='Маршрутна карта'"), ДанныеЭтапа.МаршрутнаяКартаПредставление, ТаблицаСвойств, ПолеЗначения);
	
	ДобавитьСвойство(НСтр("ru='Планировать работу видов рабочих центров';uk='Планувати роботу видів робочих центрів'"), ДанныеЭтапа.ПланироватьРаботуВидовРабочихЦентров, ТаблицаСвойств, ПолеЗначения);
	//-- НЕ УТКА
	
	Если ДанныеЭтапа.ПланироватьРаботуВидовРабочихЦентров Тогда
		//++ НЕ УТКА
		ДобавитьСвойство(НСтр("ru='Предварительный буфер';uk='Попередній буфер'"), 
						Строка(ДанныеЭтапа.ПредварительныйБуфер) + " (" + ДанныеЭтапа.ЕдиницаИзмеренияПредварительногоБуфера + ")", 
						ТаблицаСвойств, 
						ПолеЗначения);
						
		ДобавитьСвойство(НСтр("ru='Завершающий буфер';uk='Завершальний буфер'"), 
						Строка(ДанныеЭтапа.ЗавершающийБуфер) + " (" + ДанныеЭтапа.ЕдиницаИзмеренияЗавершающегоБуфера + ")",
						ТаблицаСвойств, 
						ПолеЗначения);
						
		ДобавитьСвойство(НСтр("ru='Непрерывный';uk='Безперервний'"), 
						Формат(ДанныеЭтапа.Непрерывный, "БЛ=Нет; БИ=Да"),
						ТаблицаСвойств, 
						ПолеЗначения);
		//-- НЕ УТКА
	Иначе
		ДобавитьСвойство(НСтр("ru='Длительность этапа';uk='Тривалість етапу'"), 
						Строка(ДанныеЭтапа.ДлительностьЭтапа) + " (" + Перечисления.ЕдиницыИзмеренияВремени.День + ")",
						ТаблицаСвойств,
						ПолеЗначения);
	КонецЕсли; 
	
	ДобавитьСвойство(НСтр("ru='Описание';uk='Опис'"), ДанныеЭтапа.Описание, ТаблицаСвойств, ПолеЗначения);
	
КонецПроцедуры

Процедура ДобавитьДанныеПоНоменклатуре(КоллекцияСтрокТЧ, ДанныеТЧ, ПолеЗначения)
	
	Для каждого ЭлКоллекции Из КоллекцияСтрокТЧ Цикл
		НайденныеСтроки = ДанныеТЧ.НайтиСтроки(Новый Структура("Номенклатура,Характеристика", ЭлКоллекции.Номенклатура, ЭлКоллекции.Характеристика));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокаТЧ = ДанныеТЧ.Добавить();
			СтрокаТЧ.Номенклатура   = ЭлКоллекции.Номенклатура;
			СтрокаТЧ.Характеристика = ЭлКоллекции.Характеристика;
			СтрокаТЧ.Свойство = ЭлКоллекции.НоменклатураПредставление + ?(ЗначениеЗаполнено(ЭлКоллекции.ХарактеристикаПредставление), "," + ЭлКоллекции.ХарактеристикаПредставление, "");
			СтрокаТЧ.Значения = Новый Структура;
		Иначе
			СтрокаТЧ = НайденныеСтроки[0];
		КонецЕсли;
		
		СтрокаТЧ.Значения.Вставить(ПолеЗначения, Строка(ЭлКоллекции.КоличествоУпаковок) + " (" + ЭлКоллекции.ЕдИзм + ")");
	КонецЦикла;
	
КонецПроцедуры

//++ НЕ УТКА

Процедура ДобавитьДанныеПоВидамРЦ(КоллекцияСтрокТЧ, ДанныеТЧ, ПолеЗначения)
	
	Для каждого ЭлКоллекции Из КоллекцияСтрокТЧ Цикл
		НайденныеСтроки = ДанныеТЧ.НайтиСтроки(Новый Структура("ВидРабочегоЦентра", ЭлКоллекции.ВидРабочегоЦентра));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокаТЧ = ДанныеТЧ.Добавить();
			СтрокаТЧ.ВидРабочегоЦентра  = ЭлКоллекции.ВидРабочегоЦентра;
			СтрокаТЧ.Свойство = ЭлКоллекции.ВидРабочегоЦентраПредставление;
			СтрокаТЧ.Значения = Новый Структура;
		Иначе
			СтрокаТЧ = НайденныеСтроки[0];
		КонецЕсли;
		
		СтрокаТЧ.Значения.Вставить(ПолеЗначения, Строка(ЭлКоллекции.ВремяРаботы) + " (" + ЭлКоллекции.ЕдиницаИзмерения + ")");
	КонецЦикла;
	
КонецПроцедуры

//-- НЕ УТКА

Процедура ПолучитьДанныеСпецификаций(ДанныеСравнения, СписокСпецификаций)
	
	// Получим данные
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Этапы.Владелец КАК Спецификация,
	|	Этапы.Владелец.МногоэтапныйПроизводственныйПроцесс КАК Многоэтапный,
	|	Этапы.Владелец.Представление КАК СпецификацияПредставление,
	|	Этапы.Наименование КАК КлючЭтапа,
	|	Этапы.НомерЭтапа КАК НомерЭтапа,
	|	Этапы.НомерСледующегоЭтапа КАК НомерСледующегоЭтапа,
	|	ЕСТЬNULL(Этапы.Подразделение.Представление, """")   КАК ПодразделениеПредставление,
	//++ НЕ УТКА
	|	ЕСТЬNULL(Этапы.МаршрутнаяКарта.Представление, """") КАК МаршрутнаяКартаПредставление,
	//-- НЕ УТКА
	|	Этапы.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий,
	|	Этапы.ПланироватьРаботуВидовРабочихЦентров,
	|	Этапы.ДлительностьЭтапа,
	|	Этапы.ПредварительныйБуфер,
	|	Этапы.ЗавершающийБуфер,
	|	Этапы.ЕдиницаИзмеренияПредварительногоБуфера,
	|	Этапы.ЕдиницаИзмеренияЗавершающегоБуфера,
	|	Этапы.Непрерывный,
	|	Этапы.Описание
	|ИЗ
	|	Справочник.ЭтапыПроизводства КАК Этапы
	|ГДЕ
	|	(НЕ Этапы.ПометкаУдаления)
	|	И Этапы.Владелец В(&СписокСпецификаций)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЭтапа,
	|	НомерСледующегоЭтапа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеТЧ.Ссылка КАК Спецификация,
	|	ДанныеТЧ.Этап.Наименование КАК КлючЭтапа,
	|	ДанныеТЧ.Номенклатура КАК Номенклатура,
	|	ДанныеТЧ.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ДанныеТЧ.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ЕСТЬNULL(ДанныеТЧ.Упаковка.Представление, """")
	|		ИНАЧЕ ЕСТЬNULL(ДанныеТЧ.Номенклатура.ЕдиницаИзмерения.Представление, """")
	|	КОНЕЦ КАК ЕдИзм,
	|	ДанныеТЧ.КоличествоУпаковок,
	|	ДанныеТЧ.ДоляСтоимости,
	|	ЕСТЬNULL(ДанныеТЧ.Номенклатура.Представление, """") КАК НоменклатураПредставление,
	|	ЕСТЬNULL(ДанныеТЧ.Характеристика.Представление, """") КАК ХарактеристикаПредставление
	|ИЗ
	|	Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК ДанныеТЧ
	|ГДЕ
	|	ДанныеТЧ.Ссылка В(&СписокСпецификаций)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеТЧ.Ссылка КАК Спецификация,
	|	ДанныеТЧ.Этап.Наименование КАК КлючЭтапа,
	|	ДанныеТЧ.Номенклатура КАК Номенклатура,
	|	ДанныеТЧ.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ДанныеТЧ.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ЕСТЬNULL(ДанныеТЧ.Упаковка.Представление, """")
	|		ИНАЧЕ ЕСТЬNULL(ДанныеТЧ.Номенклатура.ЕдиницаИзмерения.Представление, """")
	|	КОНЕЦ КАК ЕдИзм,
	|	ДанныеТЧ.КоличествоУпаковок,
	|	ДанныеТЧ.СтатьяКалькуляции,
	|	ЕСТЬNULL(ДанныеТЧ.Номенклатура.Представление, """") КАК НоменклатураПредставление,
	|	ЕСТЬNULL(ДанныеТЧ.Характеристика.Представление, """") КАК ХарактеристикаПредставление
	|ИЗ
	|	Справочник.РесурсныеСпецификации.ВозвратныеОтходы КАК ДанныеТЧ
	|ГДЕ
	|	ДанныеТЧ.Ссылка В(&СписокСпецификаций)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеТЧ.Ссылка КАК Спецификация,
	|	ДанныеТЧ.Этап.Наименование КАК КлючЭтапа,
	|	ДанныеТЧ.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ДанныеТЧ.Номенклатура.Представление, """") КАК НоменклатураПредставление,
	|	ДанныеТЧ.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(ДанныеТЧ.Характеристика.Представление, """") КАК ХарактеристикаПредставление,
	|	ВЫБОР
	|		КОГДА ДанныеТЧ.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ЕСТЬNULL(ДанныеТЧ.Упаковка.Представление, """")
	|		ИНАЧЕ ЕСТЬNULL(ДанныеТЧ.Номенклатура.ЕдиницаИзмерения.Представление, """")
	|	КОНЕЦ КАК ЕдИзм,
	|	ДанныеТЧ.КоличествоУпаковок,
	|	ДанныеТЧ.ПроизводитсяВПроцессе,
	|	ДанныеТЧ.ИсточникПолученияПолуфабриката,
	|	ДанныеТЧ.СтатьяКалькуляции
	|ИЗ
	|	Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК ДанныеТЧ
	|ГДЕ
	|	ДанныеТЧ.Ссылка В(&СписокСпецификаций)
	//++ НЕ УТКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Этапы.Владелец КАК Спецификация,
	|	Этапы.Наименование КАК КлючЭтапа,
	|	ДанныеТЧ.ВидРабочегоЦентра КАК ВидРабочегоЦентра,
	|	ЕСТЬNULL(ДанныеТЧ.ВидРабочегоЦентра.Представление, """") КАК ВидРабочегоЦентраПредставление,
	|	ВЫБОР
	|		КОГДА ДанныеТЧ.ВидРабочегоЦентра.ПараллельнаяЗагрузка
	|				И ДанныеТЧ.ВидРабочегоЦентра.ВариантЗагрузки = ЗНАЧЕНИЕ(Перечисление.ВариантыЗагрузкиРабочихЦентров.Синхронный)
	|				И НЕ ДанныеТЧ.ВидРабочегоЦентра.ИспользуютсяВариантыНаладки
	|			ТОГДА ДанныеТЧ.ВидРабочегоЦентра.ВремяРаботы
	|		КОГДА ДанныеТЧ.ВидРабочегоЦентра.ПараллельнаяЗагрузка
	|				И ДанныеТЧ.ВидРабочегоЦентра.ВариантЗагрузки = ЗНАЧЕНИЕ(Перечисление.ВариантыЗагрузкиРабочихЦентров.Синхронный)
	|				И ДанныеТЧ.ВидРабочегоЦентра.ИспользуютсяВариантыНаладки
	|			ТОГДА ДанныеТЧ.ВариантНаладки.ВремяРаботы
	|		ИНАЧЕ ДанныеТЧ.ВремяРаботы                                           
	|	КОНЕЦ                                                                           КАК ВремяРаботы,
	|	ВЫБОР
	|		КОГДА ДанныеТЧ.ВидРабочегоЦентра.ПараллельнаяЗагрузка
	|			И ДанныеТЧ.ВидРабочегоЦентра.ВариантЗагрузки = ЗНАЧЕНИЕ(Перечисление.ВариантыЗагрузкиРабочихЦентров.Синхронный)
	|			И НЕ ДанныеТЧ.ВидРабочегоЦентра.ИспользуютсяВариантыНаладки
	|			ТОГДА ДанныеТЧ.ВидРабочегоЦентра.ЕдиницаИзмерения
	|		КОГДА ДанныеТЧ.ВидРабочегоЦентра.ПараллельнаяЗагрузка
	|			И ДанныеТЧ.ВидРабочегоЦентра.ВариантЗагрузки = ЗНАЧЕНИЕ(Перечисление.ВариантыЗагрузкиРабочихЦентров.Синхронный)
	|			И ДанныеТЧ.ВидРабочегоЦентра.ИспользуютсяВариантыНаладки
	|			ТОГДА ДанныеТЧ.ВариантНаладки.ЕдиницаИзмерения
	|		ИНАЧЕ ДанныеТЧ.ЕдиницаИзмерения                                           
	|	КОНЕЦ                                                                           КАК ЕдиницаИзмерения
	|ИЗ
	|	Справочник.ЭтапыПроизводства КАК Этапы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭтапыПроизводства.ВидыРабочихЦентров КАК ДанныеТЧ
	|		ПО ДанныеТЧ.Ссылка = Этапы.Ссылка
	|ГДЕ
	|	(НЕ Этапы.ПометкаУдаления)
	|	И Этапы.Владелец В(&СписокСпецификаций)
	//-- НЕ УТКА
	|");
	
	Запрос.УстановитьПараметр("СписокСпецификаций", СписокСпецификаций);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаИзделий    = Результат[1].Выгрузить();
	ТаблицаОтходов    = Результат[2].Выгрузить();
	ТаблицаМатериалов = Результат[3].Выгрузить();
	//++ НЕ УТКА
	ТаблицаВидыРЦ     = Результат[4].Выгрузить();
	//-- НЕ УТКА
	
	ВыборкаЭтапов = Результат[0].Выбрать();
	
	Пока ВыборкаЭтапов.Следующий() Цикл
		
		ОбъектСравнения = ВыборкаЭтапов.Спецификация;
		
		КлючЭтапа = ВыборкаЭтапов.КлючЭтапа;
		ПолеЗначения = "Значение" + Формат(СписокСпецификаций.Индекс(СписокСпецификаций.НайтиПоЗначению(ОбъектСравнения)), "ЧГ=");
		
		СтрокаЭтап = ДанныеСравнения.СписокЭтапов.НайтиПоЗначению(КлючЭтапа);
		
		Если СтрокаЭтап = Неопределено Тогда
			
			ПредставлениеЭтапа = Строка(ВыборкаЭтапов.КлючЭтапа) + " (" + ВыборкаЭтапов.СпецификацияПредставление + ")";
			
			ДанныеСравнения.СписокЭтапов.Добавить(КлючЭтапа, ПредставлениеЭтапа);
			
			ДанныеСравненияЭтапа = ПолучитьСтруктуруДанныхСравнения();
			
			ДанныеСравнения.ДанныеСравнения.Вставить(КлючЭтапа, ДанныеСравненияЭтапа);
			
			ДанныеСравненияЭтапа.СписокСпецификаций = Новый Массив;
			
		Иначе
			
			ДанныеСравненияЭтапа = ДанныеСравнения.ДанныеСравнения.Получить(КлючЭтапа);
			
		КонецЕсли; 
		
		ДанныеСравненияЭтапа.СписокСпецификаций.Добавить(ОбъектСравнения);
		
		ДобавитьСвойстваЭтапа(ВыборкаЭтапов, ДанныеСравненияЭтапа.ТаблицаСвойств, ПолеЗначения);
		
		Если ВыборкаЭтапов.Многоэтапный Тогда
			СтруктураПоискаДанных = Новый Структура("Спецификация, КлючЭтапа", ВыборкаЭтапов.Спецификация, ВыборкаЭтапов.КлючЭтапа);
		Иначе	
			СтруктураПоискаДанных = Новый Структура("Спецификация", ВыборкаЭтапов.Спецификация);
		КонецЕсли;		
		
		// ВыходныеИзделия
		ДанныеТЧ = ТаблицаИзделий.НайтиСтроки(СтруктураПоискаДанных);
		ДобавитьДанныеПоНоменклатуре(ДанныеТЧ, ДанныеСравненияЭтапа.ТаблицаИзделий, ПолеЗначения);
		
		// ВозвратныеОтходы
		ДанныеТЧ = ТаблицаОтходов.НайтиСтроки(СтруктураПоискаДанных);
		ДобавитьДанныеПоНоменклатуре(ДанныеТЧ, ДанныеСравненияЭтапа.ТаблицаОтходов, ПолеЗначения);
		
		// МатериалыИУслуги
		ДанныеТЧ = ТаблицаМатериалов.НайтиСтроки(СтруктураПоискаДанных);
		ДобавитьДанныеПоНоменклатуре(ДанныеТЧ, ДанныеСравненияЭтапа.ТаблицаМатериалов, ПолеЗначения);
		
		//++ НЕ УТКА
		
		// ВидыРабочихЦентров
		ДанныеТЧ = ТаблицаВидыРЦ.НайтиСтроки(СтруктураПоискаДанных);
		ДобавитьДанныеПоВидамРЦ(ДанныеТЧ, ДанныеСравненияЭтапа.ТаблицаВидыРЦ, ПолеЗначения);
		
		//-- НЕ УТКА
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиГруппуСвойств(НазваниеГруппы, ТаблицаСвойств, ОбластьГруппаСвойствНазвание, ОбластьГруппаСвойствИсточник, ОбластьСвойстваСтрокаНазвание, ОбластьСвойстваСтрокаИсточник, РезультатСравнения, СписокСпецификаций, ПоказатьТолькоОтличия)
	
	Если ТаблицаСвойств.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоказатьТолькоОтличия И ТаблицаСвойств.Найти(Истина, "ЕстьОтличия") = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ОбластьГруппаСвойствНазвание.Параметры.НазваниеГруппы = НазваниеГруппы;
	РезультатСравнения.Вывести(ОбластьГруппаСвойствНазвание);
	Для каждого ЭлКоллекции Из СписокСпецификаций Цикл
		ОбластьИсточник = РезультатСравнения.Присоединить(ОбластьГруппаСвойствИсточник);
	КонецЦикла;
	ОбластьИсточник.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	РезультатСравнения.НачатьГруппуСтрок(НазваниеГруппы);
	
	Для каждого ДанныеСвойства Из ТаблицаСвойств Цикл
		Если ПоказатьТолькоОтличия И НЕ ДанныеСвойства.ЕстьОтличия Тогда
			Продолжить;
		КонецЕсли; 
		
		ОбластьСвойстваСтрокаНазвание.Параметры.Свойство = ДанныеСвойства.Свойство;
		ОбластьИсточник = РезультатСравнения.Вывести(ОбластьСвойстваСтрокаНазвание);
		Если НЕ ПоказатьТолькоОтличия И ДанныеСвойства.ЕстьОтличия Тогда
			ОбластьИсточник.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
		КонецЕсли; 
		
		Для каждого ЭлКоллекции Из СписокСпецификаций Цикл
			ИмяПоляЗначений = "Значение" + Формат(СписокСпецификаций.Индекс(ЭлКоллекции), "ЧГ="); 
			
			Если ДанныеСвойства.Значения.Свойство(ИмяПоляЗначений) Тогда
				ОбластьСвойстваСтрокаИсточник.Параметры.ЗначениеИсточника = ДанныеСвойства.Значения[ИмяПоляЗначений];
			Иначе
				ОбластьСвойстваСтрокаИсточник.Параметры.ЗначениеИсточника = "";
			КонецЕсли;
			ОбластьИсточник = РезультатСравнения.Присоединить(ОбластьСвойстваСтрокаИсточник);
			Если НЕ ПоказатьТолькоОтличия И ДанныеСвойства.ЕстьОтличия Тогда
				ОбластьИсточник.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			КонецЕсли; 
		КонецЦикла;
		
	КонецЦикла; 
	
	РезультатСравнения.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли