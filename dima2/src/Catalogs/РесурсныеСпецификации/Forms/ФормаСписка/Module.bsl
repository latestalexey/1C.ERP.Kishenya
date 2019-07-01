#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДоступенОтборИспользуетсяВЗаказах = Ложь;
	//++ НЕ УТКА
	ДоступенОтборИспользуетсяВЗаказах = ПравоДоступа("Чтение", Метаданные.Документы.ЗаказНаПроизводство);
	//-- НЕ УТКА
	
	УстановитьТекстЗапросаСписка();
	
	// Нужно вызвать установку отбора, чтобы установить параметры динамического списка
	УстановитьОтборПоИзделию(ЭтаФорма);
	УстановитьОтборПоМатериалу(ЭтаФорма);
	//++ НЕ УТКА
	УстановитьОтборПоВидуРабочегоЦентра(ЭтаФорма);
	УстановитьОтборПоВариантуНаладки(ЭтаФорма);
	УстановитьОтборПоИспользованиюВЗаказах(ЭтаФорма);
	//-- НЕ УТКА
	
	Если Параметры.Свойство("Изделие") Тогда
		// Форма открывается из карточки номенклатуры
		ОтборИзделие = Параметры.Изделие;		
		УстановитьОтборПоИзделию(ЭтаФорма);
		НеЗагружатьНастройки = Истина;
	КонецЕсли;
	
	ПравоРедактированияСпецификаций = ПравоДоступа("Редактирование", Метаданные.Справочники.РесурсныеСпецификации);
	Если НЕ ПравоРедактированияСпецификаций Тогда
		Элементы.СписокУстановитьСтатусВРазработке.Видимость = Ложь;
		Элементы.СписокУстановитьСтатусДействует.Видимость = Ложь;
		Элементы.СписокУстановитьСтатусЗакрыта.Видимость = Ложь;
	КонецЕсли; 
	
	//++ НЕ УТКА
	Если НЕ ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.ПрименениеНоменклатурыВПроизводстве) Тогда
		Элементы.СписокОткрытьСпецификацииИзделия.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ УТКА
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	Если НЕ ДоступенОтборИспользуетсяВЗаказах Тогда
		Элементы.ОтборИспользуетсяВЗаказах.Видимость = Ложь;
	КонецЕсли; 
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОсновныеСпецификации" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Настройки.Удалить("ОтборСтатус");
		Настройки.Удалить("ОтборИзделие");
		Настройки.Удалить("ОтборМатериал");
		Настройки.Удалить("ОтборВидРабочегоЦентра");
		Настройки.Удалить("ОтборИспользуетсяВЗаказах");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	УстановитьОтборПоИзделию(ЭтаФорма);
	УстановитьОтборПоМатериалу(ЭтаФорма);
	//++ НЕ УТКА
	УстановитьОтборПоВидуРабочегоЦентра(ЭтаФорма);
	УстановитьОтборПоВариантуНаладки(ЭтаФорма);
	УстановитьОтборПоИспользованиюВЗаказах(ЭтаФорма);
	//-- НЕ УТКА
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИзделиеПриИзменении(Элемент)
	
	УстановитьОтборПоИзделию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМатериалПриИзменении(Элемент)
	
	УстановитьОтборПоМатериалу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидРабочегоЦентраПриИзменении(Элемент)
	
	//++ НЕ УТКА
	УстановитьОтборПоВидуРабочегоЦентра(ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВариантНаладкиПриИзменении(Элемент)
	
	//++ НЕ УТКА
	УстановитьОтборПоВариантуНаладки(ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИспользуетсяВЗаказахПриИзменении(Элемент)
	
	//++ НЕ УТКА
	УстановитьОтборПоИспользованиюВЗаказах(ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ВыбраннаяСтрока.Ключ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Группа Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Копирование Тогда
		
		Отказ = Истина;
		
		КопироватьРесурснуюСпецификацию();
		
	ИначеЕсли НЕ ОтборИзделие.Пустая() Тогда
		
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ОтборИзделие);
		ОткрытьФорму("Справочник.РесурсныеСпецификации.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУстановитьСтатусВРазработке(Команда)
	
	УстановитьСтатусСпецификации("ВРазработке", НСтр("ru='В разработке';uk='В розробці'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусДействует(Команда)
	
	УстановитьСтатусСпецификации("Действует", НСтр("ru='Действует';uk='Діє'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусЗакрыта(Команда)
	
	УстановитьСтатусСпецификации("Закрыта", НСтр("ru='Закрыта';uk='Закрита'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьСпецификацииИзделия(Команда)
	
	//++ НЕ УТКА
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТипЗнч(ТекущиеДанные) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание,РежимСпецификацииИзделия,АктивизироватьСпецификацию", 
								ТекущиеДанные.ОсновноеИзделие, Истина, ТекущиеДанные.Ссылка);
	ОткрытьФорму("ОбщаяФорма.ПрименениеНоменклатурыВПроизводстве", ПараметрыФормы,, ТекущиеДанные.ОсновноеИзделие);
	
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отборы

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Статус", 
		Форма.ОтборСтатус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборСтатус));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИзделию(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураИзделие", Форма.ОтборИзделие);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоМатериалу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураМатериал", Форма.ОтборМатериал);
	
КонецПроцедуры

//++ НЕ УТКА

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИспользованиюВЗаказах(Форма)

	Если Форма.ДоступенОтборИспользуетсяВЗаказах Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "ОтборИспользуетсяВЗаказах", Форма.ОтборИспользуетсяВЗаказах);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоВидуРабочегоЦентра(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "ОтборВидРабочегоЦентра", Форма.ОтборВидРабочегоЦентра);
	
	Если НЕ Форма.ОтборВидРабочегоЦентра.Пустая() Тогда
		ИспользуютсяВариантыНаладки = ИспользуютсяВариантыНаладки(Форма.ОтборВидРабочегоЦентра);
	Иначе
		ИспользуютсяВариантыНаладки = Ложь;
	КонецЕсли;
	
	Форма.Элементы.ОтборВариантНаладки.ТолькоПросмотр = НЕ ИспользуютсяВариантыНаладки;
	
	УстановитьОтборПоВариантуНаладки(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуютсяВариантыНаладки(Знач ВариантНаладки)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантНаладки, "ИспользуютсяВариантыНаладки");

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоВариантуНаладки(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "ОтборВариантНаладки", Форма.ОтборВариантНаладки);

КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	УправлениеДаннымиОбИзделиях.УстановитьУсловноеОформлениеСпискаСпецификаций(Список.УсловноеОформление);

	// Выделение серым цветом отбора по использованию в заказах
	Если ДоступенОтборИспользуетсяВЗаказах Тогда
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборИспользуетсяВЗаказах.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборИспользуетсяВЗаказах");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "";
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьРесурснуюСпецификацию()

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТипЗнч(ТекущиеДанные) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КопироватьРесурснуюСпецификациюЗавершение", ЭтотОбъект);
	УправлениеДаннымиОбИзделияхКлиент.КопироватьРесурснуюСпецификацию(ТекущиеДанные.Ссылка, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура КопироватьРесурснуюСпецификациюЗавершение(Ссылка, ДополнительныеПараметры) Экспорт

	Если Ссылка <> Неопределено Тогда
		Элементы.Список.ТекущаяСтрока = Ссылка;
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСпецификации(ЗначениеСтатуса, ПредставлениеСтатуса)

	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	УправлениеДаннымиОбИзделияхКлиент.УстановитьСтатусСпецификаций(ЗначениеСтатуса, ПредставлениеСтатуса, ВыделенныеСсылки);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапросаСписка()

	Если ДоступенОтборИспользуетсяВЗаказах Тогда
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникРесурсныеСпецификации.Ссылка,
		|	СправочникРесурсныеСпецификации.Код,
		|	СправочникРесурсныеСпецификации.Наименование,
		|	СправочникРесурсныеСпецификации.Статус,
		|	СправочникРесурсныеСпецификации.НачалоДействия,
		|	СправочникРесурсныеСпецификации.КонецДействия,
		|	СправочникРесурсныеСпецификации.Ответственный,
		|	СправочникРесурсныеСпецификации.Описание,
		|	ЕСТЬNULL(ОсновныеСпецификации.ОсновнаяСпецификация, ЛОЖЬ) КАК ОсновнаяСпецификация,
		|	ЕСТЬNULL(ТаблицаОсновныеВыходныеИзделия.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ОсновноеИзделие,
		|	ВЫБОР
		|		КОГДА НЕ ТаблицаВыходныеИзделия.Ссылка ЕСТЬ NULL 
		|			ТОГДА &НоменклатураИзделие
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	КОНЕЦ КАК НоменклатураИзделие,
		|	ВЫБОР
		|		КОГДА НЕ ТаблицаМатериалыИУслуги.Ссылка ЕСТЬ NULL 
		|			ТОГДА &НоменклатураМатериал
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	КОНЕЦ КАК НоменклатураМатериал
		|ИЗ
		|	Справочник.РесурсныеСпецификации КАК СправочникРесурсныеСпецификации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК ТаблицаОсновныеВыходныеИзделия
		|		ПО (ТаблицаОсновныеВыходныеИзделия.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|			И (ТаблицаОсновныеВыходныеИзделия.НомерСтроки = 1)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ТаблицаВыходныеИзделия.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК ТаблицаВыходныеИзделия
		|		ГДЕ
		|			ТаблицаВыходныеИзделия.Номенклатура = &НоменклатураИзделие
		|			И &НоменклатураИзделие <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ТаблицаВыходныеИзделия
		|		ПО (ТаблицаВыходныеИзделия.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ТаблицаМатериалыИУслуги.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
		|		ГДЕ
		|			&НоменклатураМатериал <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			И ТаблицаМатериалыИУслуги.Номенклатура = &НоменклатураМатериал) КАК ТаблицаМатериалыИУслуги
		|		ПО (ТаблицаМатериалыИУслуги.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ОсновныеСпецификации.Спецификация КАК Спецификация,
		|			ИСТИНА КАК ОсновнаяСпецификация
		|		ИЗ
		|			РегистрСведений.ОсновныеСпецификации КАК ОсновныеСпецификации
		|		ГДЕ
		|			ОсновныеСпецификации.Номенклатура = &НоменклатураИзделие
		|			И &НоменклатураИзделие <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ОсновныеСпецификации
		|		ПО СправочникРесурсныеСпецификации.Ссылка = ОсновныеСпецификации.Спецификация
		//++ НЕ УТКА
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ВидыРабочихЦентровЭтапов.Ссылка.Владелец КАК Ссылка
		|		ИЗ
		|			Справочник.ЭтапыПроизводства.ВидыРабочихЦентров КАК ВидыРабочихЦентровЭтапов
		|		ГДЕ
		|			(&ОтборВидРабочегоЦентра <> ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка)
		|					ИЛИ &ОтборВариантНаладки <> ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка))
		|			И (ВидыРабочихЦентровЭтапов.ВидРабочегоЦентра = &ОтборВидРабочегоЦентра
		|					ИЛИ &ОтборВидРабочегоЦентра = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка))
		|			И (ВидыРабочихЦентровЭтапов.ВариантНаладки = &ОтборВариантНаладки
		|					ИЛИ &ОтборВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка))) КАК ТаблицаВидыРабочихЦентровЭтапов
		|		ПО (ТаблицаВидыРабочихЦентровЭтапов.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		//-- НЕ УТКА
		
		|ГДЕ
		|	(&НоменклатураИзделие = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВыходныеИзделия.Ссылка ЕСТЬ NULL )
		|	И (&НоменклатураМатериал = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаМатериалыИУслуги.Ссылка ЕСТЬ NULL )
		//++ НЕ УТКА
		|	И (&ОтборВидРабочегоЦентра = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВидыРабочихЦентровЭтапов.Ссылка ЕСТЬ NULL )
		|	И (&ОтборВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВидыРабочихЦентровЭтапов.Ссылка ЕСТЬ NULL )
		|	И (&ОтборИспользуетсяВЗаказах = """"
		|			ИЛИ &ОтборИспользуетсяВЗаказах = ""Используется""
		|				И СправочникРесурсныеСпецификации.Ссылка В
		|					(ВЫБРАТЬ
		|						ТаблицаПродукция.Спецификация КАК Спецификация
		|					ИЗ
		|						Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
		|					ГДЕ
		|						ТаблицаПродукция.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
		|						И НЕ ТаблицаПродукция.Ссылка.ПометкаУдаления
		|						И &ОтборИспользуетсяВЗаказах = ""Используется""
		|		
		|					ОБЪЕДИНИТЬ ВСЕ
		|		
		|					ВЫБРАТЬ
		|						ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката
		|					ИЗ
		|						Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
		|					ГДЕ
		|						ТаблицаМатериалыИУслуги.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
		|						И НЕ ТаблицаМатериалыИУслуги.Ссылка.ПометкаУдаления
		|						И ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката ССЫЛКА Справочник.РесурсныеСпецификации
		|						И ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката <> ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаяСсылка)
		|						И &ОтборИспользуетсяВЗаказах = ""Используется"")
		|			ИЛИ &ОтборИспользуетсяВЗаказах = ""НеИспользуется""
		|				И НЕ СправочникРесурсныеСпецификации.Ссылка В
		|						(ВЫБРАТЬ
		|							ТаблицаПродукция.Спецификация КАК Спецификация
		|						ИЗ
		|							Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
		|						ГДЕ
		|							ТаблицаПродукция.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
		|							И НЕ ТаблицаПродукция.Ссылка.ПометкаУдаления
		|							И &ОтборИспользуетсяВЗаказах = ""НеИспользуется""
		|		
		|						ОБЪЕДИНИТЬ ВСЕ
		|		
		|						ВЫБРАТЬ
		|							ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката
		|						ИЗ
		|							Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
		|						ГДЕ
		|							ТаблицаМатериалыИУслуги.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
		|							И НЕ ТаблицаМатериалыИУслуги.Ссылка.ПометкаУдаления
		|							И ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката ССЫЛКА Справочник.РесурсныеСпецификации
		|							И ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката <> ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаяСсылка)
		|							И &ОтборИспользуетсяВЗаказах = ""НеИспользуется""))
		//-- НЕ УТКА
		|";
		
	Иначе
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникРесурсныеСпецификации.Ссылка,
		|	СправочникРесурсныеСпецификации.Код,
		|	СправочникРесурсныеСпецификации.Наименование,
		|	СправочникРесурсныеСпецификации.Статус,
		|	СправочникРесурсныеСпецификации.НачалоДействия,
		|	СправочникРесурсныеСпецификации.КонецДействия,
		|	СправочникРесурсныеСпецификации.Ответственный,
		|	СправочникРесурсныеСпецификации.Описание,
		|	ЕСТЬNULL(ОсновныеСпецификации.ОсновнаяСпецификация, ЛОЖЬ) КАК ОсновнаяСпецификация,
		|	ЕСТЬNULL(ТаблицаОсновныеВыходныеИзделия.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ОсновноеИзделие,
		|	ВЫБОР
		|		КОГДА НЕ ТаблицаВыходныеИзделия.Ссылка ЕСТЬ NULL 
		|			ТОГДА &НоменклатураИзделие
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	КОНЕЦ КАК НоменклатураИзделие,
		|	ВЫБОР
		|		КОГДА НЕ ТаблицаМатериалыИУслуги.Ссылка ЕСТЬ NULL 
		|			ТОГДА &НоменклатураМатериал
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	КОНЕЦ КАК НоменклатураМатериал
		|ИЗ
		|	Справочник.РесурсныеСпецификации КАК СправочникРесурсныеСпецификации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК ТаблицаОсновныеВыходныеИзделия
		|		ПО (ТаблицаОсновныеВыходныеИзделия.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|			И (ТаблицаОсновныеВыходныеИзделия.НомерСтроки = 1)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ТаблицаВыходныеИзделия.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК ТаблицаВыходныеИзделия
		|		ГДЕ
		|			ТаблицаВыходныеИзделия.Номенклатура = &НоменклатураИзделие
		|			И &НоменклатураИзделие <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ТаблицаВыходныеИзделия
		|		ПО (ТаблицаВыходныеИзделия.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ТаблицаМатериалыИУслуги.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
		|		ГДЕ
		|			&НоменклатураМатериал <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			И ТаблицаМатериалыИУслуги.Номенклатура = &НоменклатураМатериал) КАК ТаблицаМатериалыИУслуги
		|		ПО (ТаблицаМатериалыИУслуги.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ОсновныеСпецификации.Спецификация КАК Спецификация,
		|			ИСТИНА КАК ОсновнаяСпецификация
		|		ИЗ
		|			РегистрСведений.ОсновныеСпецификации КАК ОсновныеСпецификации
		|		ГДЕ
		|			ОсновныеСпецификации.Номенклатура = &НоменклатураИзделие
		|			И &НоменклатураИзделие <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ОсновныеСпецификации
		|		ПО СправочникРесурсныеСпецификации.Ссылка = ОсновныеСпецификации.Спецификация
		//++ НЕ УТКА
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ВидыРабочихЦентровЭтапов.Ссылка.Владелец КАК Ссылка
		|		ИЗ
		|			Справочник.ЭтапыПроизводства.ВидыРабочихЦентров КАК ВидыРабочихЦентровЭтапов
		|		ГДЕ
		|			(&ОтборВидРабочегоЦентра <> ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка)
		|					ИЛИ &ОтборВариантНаладки <> ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка))
		|			И (ВидыРабочихЦентровЭтапов.ВидРабочегоЦентра = &ОтборВидРабочегоЦентра
		|					ИЛИ &ОтборВидРабочегоЦентра = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка))
		|			И (ВидыРабочихЦентровЭтапов.ВариантНаладки = &ОтборВариантНаладки
		|					ИЛИ &ОтборВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка))) КАК ТаблицаВидыРабочихЦентровЭтапов
		|		ПО (ТаблицаВидыРабочихЦентровЭтапов.Ссылка = СправочникРесурсныеСпецификации.Ссылка)
		//-- НЕ УТКА
		|ГДЕ
		|	(&НоменклатураИзделие = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВыходныеИзделия.Ссылка ЕСТЬ NULL )
		|	И (&НоменклатураМатериал = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаМатериалыИУслуги.Ссылка ЕСТЬ NULL )
		//++ НЕ УТКА
		|	И (&ОтборВидРабочегоЦентра = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВидыРабочихЦентровЭтапов.Ссылка ЕСТЬ NULL )
		|	И (&ОтборВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка)
		|			ИЛИ НЕ ТаблицаВидыРабочихЦентровЭтапов.Ссылка ЕСТЬ NULL )
		//-- НЕ УТКА
		|";
	КонецЕсли; 

КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

