#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.ОтборРазмещениеТоваров.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
	Обработки.СправочноеРазмещениеНоменклатуры.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Задание на размещение товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьЗаданияНаОтборРазмещениеТоваров";
	КомандаПечати.Идентификатор = "ЗаданиеНаОтборРазмещениеТовара";
	КомандаПечати.Представление = НСтр("ru='Задание на размещение товаров';uk='Завдання на розміщення товарів'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ИмяФормы", "ЗаданиеНаРазмещение");
	КомандаПечати.МестоРазмещения = "ПодменюПечать";
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.ПриходныйОрдерНаТовары) Тогда
		// Приходный ордер на товары
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.ПриходныйОрдерНаТовары";
		КомандаПечати.Идентификатор = "ПриходныйОрдерНаТовары";
		КомандаПечати.Представление = НСтр("ru='Приходный ордер на товары';uk='Прибутковий ордер на товари'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ПодменюПечать";
		ТипыОбъектовПечати = Новый Массив;
		ТипыОбъектовПечати.Добавить(Тип("ДокументСсылка.ПриходныйОрдерНаТовары"));
		КомандаПечати.ТипыОбъектовПечати = ТипыОбъектовПечати;
	КонецЕсли;
	
	// Бланк приемки товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ПриходныйОрдерНаТовары";
	КомандаПечати.Идентификатор = "БланкПриемкиТоваров";
	КомандаПечати.Представление = НСтр("ru='Бланк приемки товаров';uk='Бланк приймання товарів'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.МестоРазмещения = "ПодменюПечать";
	ТипыОбъектовПечати = Новый Массив;
	ТипыОбъектовПечати.Добавить(Тип("ДокументСсылка.ПриходныйОрдерНаТовары"));
	КомандаПечати.ТипыОбъектовПечати = ТипыОбъектовПечати;
	
	Если ПраваПользователяПовтИсп.ПечатьЭтикетокИЦенников() Тогда
	
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьЭтикетокИЦенников";
		КомандаПечати.МенеджерПечати = "Документ.ПриходныйОрдерНаТовары";
		КомандаПечати.Идентификатор = "Ценники";
		КомандаПечати.Представление = НСтр("ru='Ценники';uk='Цінники'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ПодменюПечать";
		ТипыОбъектовПечати = Новый Массив;
		ТипыОбъектовПечати.Добавить(Тип("ДокументСсылка.ПриходныйОрдерНаТовары"));
		КомандаПечати.ТипыОбъектовПечати = ТипыОбъектовПечати;
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьЭтикетокИЦенников";
		КомандаПечати.МенеджерПечати = "Документ.ПриходныйОрдерНаТовары";
		КомандаПечати.Идентификатор = "Этикетки";
		КомандаПечати.Представление = НСтр("ru='Этикетки';uk='Етикетки'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ПодменюПечать";
		ТипыОбъектовПечати = Новый Массив;
		ТипыОбъектовПечати.Добавить(Тип("ДокументСсылка.ПриходныйОрдерНаТовары"));
		КомандаПечати.ТипыОбъектовПечати = ТипыОбъектовПечати;

		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьЭтикетокИЦенников";
		КомандаПечати.МенеджерПечати = "Документ.ОтборРазмещениеТоваров";
		КомандаПечати.Идентификатор = "Этикетки";
		КомандаПечати.Представление = НСтр("ru='Этикетки';uk='Етикетки'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ПеремещенияВРаботеГруппаКоманднаяПанель";

	КонецЕсли;
	
КонецПроцедуры

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Обработка.УправлениеПоступлением.Форма.Форма";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Обработки.УправлениеПоступлением))
		И ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриПоступлении");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей.
	// Строка с неуказанным значением склада не учитывается,
	// показатели для остальных складов увеличиваются на количество соглашений с неуказанным складом.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВсеРаспоряжения.ДокументПоступления) КАК ЗначениеПоказателя,
	|	ВсеРаспоряжения.Склад
	|ПОМЕСТИТЬ ВТРасшифровка
	|ИЗ
	|	(ВЫБРАТЬ
	|		СоглашенияСПоставщиками.Ссылка КАК ДокументПоступления,
	|		СоглашенияСПоставщиками.Склад КАК Склад
	|	ИЗ
	|		Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
	|	ГДЕ
	|		СоглашенияСПоставщиками.ВариантПриемкиТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных)
	|		И СоглашенияСПоставщиками.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|		И НЕ СоглашенияСПоставщиками.ПометкаУдаления
	|		И (СоглашенияСПоставщиками.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|				ИЛИ СоглашенияСПоставщиками.Склад.ИспользоватьОрдернуюСхемуПриПоступлении)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыКПоступлению.ДокументПоступления,
	|		ТоварыКПоступлению.Склад
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления КАК ДокументПоступления,
	|			ТоварыКПоступлениюОстаткиНаДату.Склад КАК Склад,
	|			МИНИМУМ(ВЫБОР
	|					КОГДА ТоварыКПоступлениюОстаткиНаДату.КПоступлениюОстаток - ТоварыКПоступлениюОстаткиНаДату.ПринимаетсяОстаток < 0
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ) КАК Перепоставка
	|		ИЗ
	|			РегистрНакопления.ТоварыКПоступлению.Остатки(&ДатаПоступления, Склад.ИспользоватьОрдернуюСхемуПриПоступлении) КАК ТоварыКПоступлениюОстаткиНаДату
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКПоступлению.Остатки(, Склад.ИспользоватьОрдернуюСхемуПриПоступлении) КАК ТоварыКПоступлениюОстаткиТекущие
	|				ПО ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления = ТоварыКПоступлениюОстаткиТекущие.ДокументПоступления
	|					И ТоварыКПоступлениюОстаткиНаДату.Номенклатура = ТоварыКПоступлениюОстаткиТекущие.Номенклатура
	|					И ТоварыКПоступлениюОстаткиНаДату.Характеристика = ТоварыКПоступлениюОстаткиТекущие.Характеристика
	|					И ТоварыКПоступлениюОстаткиНаДату.Склад = ТоварыКПоступлениюОстаткиТекущие.Склад
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления,
	|			ТоварыКПоступлениюОстаткиНаДату.Склад) КАК ТоварыКПоступлению
	|	ГДЕ
	|		НЕ ТоварыКПоступлению.Перепоставка) КАК ВсеРаспоряжения
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеРаспоряжения.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТРасшифровка.ЗначениеПоказателя + ЕСТЬNULL(ВТРасшифровкаБезСклада.ЗначениеПоказателя, 0) КАК ЗначениеПоказателя,
	|	ВТРасшифровка.Склад
	|ИЗ
	|	ВТРасшифровка КАК ВТРасшифровка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРасшифровка КАК ВТРасшифровкаБезСклада
	|		ПО (ВТРасшифровкаБезСклада.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|ГДЕ
	|	ВТРасшифровка.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)";
	
	ТекущиеДелаСлужебный.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	
	Запрос.УстановитьПараметр("ДатаПоступления", КонецДня(ОбщиеПараметрыЗапросов.ТекущаяДата));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	// Заполнение дел.
	// РаспоряженияНаПоступление
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "РаспоряженияНаПоступление";
	ДелоРодитель.Представление  = НСтр("ru='Распоряжения на поступление';uk='Розпорядження на надходження'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Склад;
	
	Для Каждого СтрокаРезультата Из Результат Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Помещение", Неопределено);
		ПараметрыОтбора.Вставить("ЗонаПриемки", Неопределено);
		
		ПредставлениеДела = "";
		ИдентификаторДела = "";
		ЗначениеДела      = 0;
		Для Каждого КолонкаРезультата Из Результат.Колонки Цикл
			ЗначениеКолонки = СтрокаРезультата[КолонкаРезультата.Имя];
			Если КолонкаРезультата.Имя = "ЗначениеПоказателя" Тогда
				ЗначениеДела = ЗначениеКолонки;
				Продолжить;
			КонецЕсли;
			ПредставлениеДела = ?(ПредставлениеДела = "", "", ", ") + Строка(ЗначениеКолонки);
			ИдентификаторДела = ?(ИдентификаторДела = "", ДелоРодитель.Идентификатор, ИдентификаторДела)
				+ СтрЗаменить(Строка(ЗначениеКолонки), " ", "");
			ПараметрыОтбора.Вставить(КолонкаРезультата.Имя, ЗначениеКолонки);
		КонецЦикла;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИдентификаторДела;
		Дело.ЕстьДела       = ЗначениеДела > 0;
		Дело.Представление  = ПредставлениеДела;
		Дело.Количество     = ЗначениеДела;
		Дело.Важное         = Ложь;
		Дело.Форма          = ИмяФормы;
		Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
		Дело.Владелец       = "РаспоряженияНаПоступление";
		
		Если ЗначениеДела > 0 Тогда
			ДелоРодитель.ЕстьДела = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
