
#Область ПрограммныйИнтерфейс

#Область ПроцедурыФормированияИОчистки

Функция ПрименитьИзмененияКСхемеКомпоновкиДанных(СегментСсылка, ИмяШаблонаСКД, АдресСКД, АдресНастроекСКД, УникальныйИдентификатор) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяШаблонаСКД", ИмяШаблонаСКД);
	ВозвращаемоеЗначение.Вставить("ПредставлениеШаблонаСКД",НСтр("ru='Произвольный';uk='Довільний'"));
	ВозвращаемоеЗначение.Вставить("АдресСКД", "");
	ВозвращаемоеЗначение.Вставить("АдресНастроекСКД","");
	
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) Тогда
		
		СхемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, ИмяШаблонаСКД);
		// Если схема компоновки данных из макета <> полученной из редактора схеме компоновки данных
		Если СегментыСервер.ПолучитьXML(СхемаИНастройки.СхемаКомпоновкиДанных) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресСКД)) Тогда
			
			ВозвращаемоеЗначение.ИмяШаблонаСКД  = "";
			ВозвращаемоеЗначение.АдресСКД = АдресСКД;
			
		Иначе
			
			ВозвращаемоеЗначение.ПредставлениеШаблонаСКД = СхемаИНастройки.Описание;
			
		КонецЕсли;
		
		// Полученные настройки могут быть равны настройкам по умолчанию схемы.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		Попытка
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаИНастройки.СхемаКомпоновкиДанных));
		Исключение
		КонецПопытки;
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.АдресСКД = АдресСКД;
		
		Схема = ПолучитьИзВременногоХранилища(АдресСКД);
		ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Схема);
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		Попытка
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
		Исключение
		КонецПопытки;
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(СегментСсылка,
	                                                            ИмяШаблонаСКД,
	                                                            АдресСКД,
	                                                            АдресНастроекСКД,
	                                                            УникальныйИдентификатор) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	// Схема
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) И ПустаяСтрока(АдресСКД) Тогда
		СхемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, ИмяШаблонаСКД);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
		Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных,УникальныйИдентификатор)
	Иначе
		Адреса.СхемаКомпоновкиДанных = АдресСКД;
	КонецЕсли;

	// Настройки
	Если НЕ ПустаяСтрока(АдресНастроекСКД) Тогда
		Адреса.НастройкиКомпоновкиДанных = АдресНастроекСКД;
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

//Заполняет регистр сведений объектами, вошедшими в сегмент
Процедура Сформировать(СегментСсылка) Экспорт

	ПР = ПривилегированныйРежим();
	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;

	СписокЭлементов = СегментыСервер.СписокЭлементовСКД(СегментСсылка);
	ВключатьХарактеристики =
		СписокЭлементов.Колонки.Найти("ХарактеристикаЭлемента") <> Неопределено;

	Если ТипЗнч(СегментСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		Для Каждого Элемент Из СписокЭлементов Цикл
			Если НЕ ЗначениеЗаполнено(Элемент.ЭлементСписка) Тогда
				Продолжить;
			КонецЕсли;
			Запись = НаборЗаписей.Добавить();
			Запись.Сегмент = СегментСсылка;
			Запись.Номенклатура = Элемент.ЭлементСписка;
			Если ВключатьХарактеристики Тогда
				Запись.Характеристика = Элемент.ХарактеристикаЭлемента;
			КонецЕсли;
		КонецЦикла;
	Иначе
		НаборЗаписей = РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		Для Каждого Элемент Из СписокЭлементов Цикл
			Если НЕ ЗначениеЗаполнено(Элемент.ЭлементСписка) Тогда
				Продолжить;
			КонецЕсли;
			Запись = НаборЗаписей.Добавить();
			Запись.Сегмент = СегментСсылка;
			Запись.Партнер = Элемент.ЭлементСписка;
		КонецЦикла;
	КонецЕсли;

	НаборЗаписей.Записать();

	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

КонецПроцедуры

//Удаляет из регистра сведений записи, относящиеся к сегменту
Процедура Очистить(СегментСсылка) Экспорт

	НаборСегмента = ?(
		ТипЗнч(СегментСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры"),
		РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей(),
		РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей());
	НаборСегмента.Отбор.Сегмент.Установить(СегментСсылка);
	НаборСегмента.Записать();

КонецПроцедуры

#КонецОбласти

#Область ФункцииОбработкиНабораЭлементов

//Возвращает список значений, содержащий элементы, входящие в сегмент,
//с учетом способа формирования сегмента
//
Функция СписокЗначений(СегментСсылка) Экспорт

	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(СегментыСервер.ТаблицаЗначений(СегментСсылка).ВыгрузитьКолонку(0));
	
	Возврат Список;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
