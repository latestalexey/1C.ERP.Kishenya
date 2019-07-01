
#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияСправочникаДляОбменаСМобильнымПриложениемТорговыйПредставитель(Источник, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ВедетсяРаботаЧерезТорговыхПредставителей") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Источник.ЭтоНовый() Тогда
		Источник.ДополнительныеСвойства.Вставить("ТребуетсяПроверитьРегистрацию", Истина);
	Иначе	
		Источник.ДополнительныеСвойства.Вставить("ВозможноУдалениеРегистрацииИзменений", Истина);
		ВыборочнаяРегистрацияОбъекта(Источник, Отказ, "МобильноеПриложениеТорговыйПредставитель");
	КонецЕсли;

КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДокументаДляОбменаСМобильнымПриложениемТорговыйПредставитель(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ВедетсяРаботаЧерезТорговыхПредставителей") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Источник.ДополнительныеСвойства.Вставить("ВозможноУдалениеРегистрацииИзменений", НЕ Источник.ЭтоНовый());
	ВыборочнаяРегистрацияОбъекта(Источник, Отказ, "МобильноеПриложениеТорговыйПредставитель");

КонецПроцедуры

Процедура ЗарегистрироватьИзмененияРегистраСведенийДляОбменаСМобильнымПриложениемТорговыйПредставитель(Источник, Отказ, Замещение) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ВедетсяРаботаЧерезТорговыхПредставителей") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Источник.ДополнительныеСвойства.Вставить("ВозможноУдалениеРегистрацииИзменений", Истина);
	ВыборочнаяРегистрацияОбъекта(Источник, Отказ, "МобильноеПриложениеТорговыйПредставитель");

КонецПроцедуры

Процедура ЗарегистрироватьИзмененияСправочникаПриЗаписиДляОбменаСМобильнымПриложениемТорговыйПредставитель(Источник, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ВедетсяРаботаЧерезТорговыхПредставителей") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяПроверитьРегистрацию = Ложь;
	Если Источник.ДополнительныеСвойства.Свойство("ТребуетсяПроверитьРегистрацию", ТребуетсяПроверитьРегистрацию) Тогда
		Если ТребуетсяПроверитьРегистрацию Тогда			
			ВыборочнаяРегистрацияОбъекта(Источник, Отказ, "МобильноеПриложениеТорговыйПредставитель");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Формирует и возвращает массив, содержащий имена полей, на которые могут накладываться отборы
//
// Параметры:
//  ИмяКласса - имя класса, к которому принадлежит объект (Справочники, Документы и т.д)
//  ИмяОбъекта - имя объекта метаданных, для которого формируется массив полей
//
// Возвращаемое значение:
//  Массив, содержащий имена полей
//
Функция ПолучитьМассивПолейОтбораДляОбъекта(ИмяКласса, ИмяОбъекта) Экспорт

	МассивПолей = Новый Массив();

	Если ИмяКласса = "Справочники" Тогда

		Если ИмяОбъекта = "Партнеры" Тогда
			МассивПолей.Добавить("ОбслуживаетсяТорговымиПредставителями");
			МассивПолей.Добавить("Клиент");
		ИначеЕсли ИмяОбъекта = "СоглашенияСКлиентами" Тогда
			МассивПолей.Добавить("Статус");
			МассивПолей.Добавить("Типовое");
		ИначеЕсли ИмяОбъекта = "ДоговорыКонтрагентов" Тогда
			МассивПолей.Добавить("Статус");
			МассивПолей.Добавить("ХозяйственнаяОперация");
		ИначеЕсли ИмяОбъекта = "Контрагенты" Тогда
			МассивПолей.Добавить("Партнер");
		ИначеЕсли ИмяОбъекта = "КонтактныеЛицаПартнеров" Тогда
			МассивПолей.Добавить("Владелец");
		ИначеЕсли ИмяОбъекта = "ВидыЦен" Тогда
			МассивПолей.Добавить("ИспользоватьПриПродаже");
		ИначеЕсли ИмяОбъекта = "УпаковкиНоменклатуры" Тогда
			МассивПолей.Добавить("Владелец");
		ИначеЕсли ИмяОбъекта = "ХарактеристикиНоменклатуры" Тогда
			МассивПолей.Добавить("Владелец");
		КонецЕсли;

	ИначеЕсли ИмяКласса = "Документы" Тогда

		Если ИмяОбъекта = "ЗаданиеТорговомуПредставителю" Тогда
			МассивПолей.Добавить("Партнер");
			МассивПолей.Добавить("Статус");
			МассивПолей.Добавить("ТорговыйПредставитель");
		КонецЕсли;

	ИначеЕсли ИмяКласса = "РегистрыСведений" Тогда

		Если ИмяОбъекта = "ЦеныНоменклатуры" Тогда
			МассивПолей.Добавить("ВидЦены");
			МассивПолей.Добавить("Номенклатура");
		ИначеЕсли ИмяОбъекта = "ДоступностьТоваровДляВнешнихПользователей" Тогда
			МассивПолей.Добавить("Номенклатура");
			МассивПолей.Добавить("Склад");
		КонецЕсли;

	КонецЕсли;

	Возврат МассивПолей;

КонецФункции

// Возвращает структуру, содержащую имя таблицы для выборки и массив полей, которые нужно выбрать
//
// Параметры:
//  ОбъектМетаданных - объект метаданных, структуру описания которого требуется получить
//  Изменения - признак того, что в качестве таблицы для выборки выступает таблица изменений
//
// Возвращаемое значение:
//  Структура, содержащая описание объекта метаданных
//
Функция ПолучитьСтруктуруОписанияОбъекта(ОбъектМетаданных, Изменения) Экспорт

	Если Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда
		ИмяКласса = "Константы";
		ИмяТаблицы = "Константы";
	ИначеЕсли Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
		ИмяКласса = "Справочники";
		ИмяТаблицы = "Справочник." + ОбъектМетаданных.Имя;
	ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		ИмяКласса = "Документы";
		ИмяТаблицы = "Документ." + ОбъектМетаданных.Имя;
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
		ИмяКласса = "РегистрыСведений";
		ИмяТаблицы = "РегистрСведений." + ОбъектМетаданных.Имя;
	КонецЕсли;	
	
	// Если требуется только выборка изменений, то выбирать необходимо по таблицам изменений
	Если Изменения Тогда
		ИмяТаблицы = ИмяТаблицы + ".Изменения";
	КонецЕсли;
	
	СтруктураОписания = Новый Структура();
	СтруктураОписания.Вставить("ИмяКласса", ИмяКласса);
	СтруктураОписания.Вставить("ИмяОбъекта", ОбъектМетаданных.Имя);
	СтруктураОписания.Вставить("ИмяТаблицы", ИмяТаблицы);
	
	Возврат СтруктураОписания;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет выборочную регистрацию изменений, с учетом правил обмена
//
// Параметры:
//  Объект - объект, изменения которого регистрируются
//  Отказ - отказ от записи объекта
//  ИмяПланаОбмена - имя используемого плана обмена
//
Процедура ВыборочнаяРегистрацияОбъекта(Объект, Отказ, ИмяПланаОбмена)
	
	// Если при записи объекта был произведен отказ, то дальнейшего анализа не требуется -
	// никаких изменений не будет
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	// Если объект не входит в состав плана обмена, то регистрировать нечего
	Если Не Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав.Содержит(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОписанияОбъекта = ПолучитьСтруктуруОписанияОбъекта(МетаданныеОбъекта, Ложь);
	
	ВыборкаУзлов = ПланыОбмена[ИмяПланаОбмена].Выбрать();

	Пока ВыборкаУзлов.Следующий() Цикл

		Если Объект.ОбменДанными.Загрузка Тогда
			Если Объект.ОбменДанными.Отправитель = ВыборкаУзлов.Ссылка Тогда
				// Для узла, по которому пришли изменения, их регистрировать не нужно
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ВыборкаУзлов.Ссылка <> ПланыОбмена[ИмяПланаОбмена].ЭтотУзел() Тогда
			
			НеРегистрироватьИзменения = Ложь;
			Если Объект.ДополнительныеСвойства.Свойство("НеРегистрироватьИзменения", НеРегистрироватьИзменения) Тогда
				Если НеРегистрироватьИзменения Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если ОбъектПодлежитРегистрацииВУзле(Объект, СтруктураОписанияОбъекта, ВыборкаУзлов.Ссылка) Тогда
				Объект.ОбменДанными.Получатели.Добавить(ВыборкаУзлов.Ссылка);
			Иначе
				ВозможноУдалениеРегистрацииИзменений = Ложь;
				Если Объект.ДополнительныеСвойства.Свойство("ВозможноУдалениеРегистрацииИзменений", ВозможноУдалениеРегистрацииИзменений) Тогда
					Если ВозможноУдалениеРегистрацииИзменений Тогда
						ПланыОбмена.УдалитьРегистрациюИзменений(ВыборкаУзлов.Ссылка, Объект);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

// Проверяет, подлежит ли объект регистрации в указанном узле обмена
//
// Параметры:
//  Объект - объект, изменения которого регистрируются
//  СтруктураОписанияОбъекта - Структура, содержащая описание объекта
//  УзелОбмена - узел плана обмена, для которого проверяется необходимость регистрации
//
Функция ОбъектПодлежитРегистрацииВУзле(Объект, СтруктураОписанияОбъекта, УзелОбмена)
	
	ИмяКласса = СтруктураОписанияОбъекта.ИмяКласса;
	ИмяОбъекта = СтруктураОписанияОбъекта.ИмяОбъекта;
	
	Если ИмяКласса = "Константы" Тогда
		// Для констант никаких условий отбора не задается, поэтому изменения регистрируем всегда
		Возврат Истина;
	Иначе
		
		МассивПолей = ПолучитьМассивПолейОтбораДляОбъекта(ИмяКласса, ИмяОбъекта);
		
		Если ИмяКласса = "Справочники" ИЛИ ИмяКласса = "Документы" Тогда
			
			Если МассивПолей.Найти("Ссылка") = Неопределено Тогда
				МассивПолей.Добавить("Ссылка");
			КонецЕсли;
			
			ТаблицаДанныхОбъекта = Новый ТаблицаЗначений();
			СтруктураРеквизитовОбъекта = Новый Структура();
			
			Для Каждого Поле из МассивПолей Цикл
				ТаблицаДанныхОбъекта.Колонки.Добавить(Поле);
			КонецЦикла;
			
			СтрокаТаблицы = ТаблицаДанныхОбъекта.Добавить();
			Для Каждого Поле из МассивПолей Цикл
				СтрокаТаблицы[Поле] = Объект[Поле];
				СтруктураРеквизитовОбъекта.Вставить(Поле, Объект[Поле]);
			КонецЦикла;
		
			Возврат МобильныеПриложения.ТребуетсяРегистрацияИзмененийОбъекта(СтруктураРеквизитовОбъекта, СтруктураОписанияОбъекта, МассивПолей, ТаблицаДанныхОбъекта, УзелОбмена);
			
		ИначеЕсли ИмяКласса = "РегистрыСведений" Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
