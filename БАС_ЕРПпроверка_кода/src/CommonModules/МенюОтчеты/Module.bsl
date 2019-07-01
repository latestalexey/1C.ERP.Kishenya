
#Область ПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере(Форма, МестоРазмещенияКомандПоУмолчанию = Неопределено, ОбъектыОснований = Неопределено, Кэшировать = Истина, ИмяМетодаМенеджераОтчеты = "ДобавитьКомандыОтчетов") Экспорт
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		ИмяФормы = Форма.ИмяФормы;
	Иначе
		ИмяФормы = Форма;
	КонецЕсли;
	
	Если МестоРазмещенияКомандПоУмолчанию <> Неопределено Тогда
		УдалитьКоманды(Форма, МестоРазмещенияКомандПоУмолчанию);
	КонецЕсли;
	
	Если ОбъектыОснований = Неопределено И Кэшировать Тогда
		КомандыОтчетов = МенюОтчетыПовтИсп.КомандыОтчетовФормы(ИмяФормы, ОбъектыОснований, ИмяМетодаМенеджераОтчеты).Скопировать();
	Иначе
		КомандыОтчетов = КомандыОтчетовФормы(Форма, ОбъектыОснований, ИмяМетодаМенеджераОтчеты).Скопировать();
	КонецЕсли;
	
	Если МестоРазмещенияКомандПоУмолчанию <> Неопределено Тогда
		Для Каждого КомандаОтчет Из КомандыОтчетов Цикл
			Если ПустаяСтрока(КомандаОтчет.МестоРазмещения) Тогда
				КомандаОтчет.МестоРазмещения = МестоРазмещенияКомандПоУмолчанию.Имя;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КомандыОтчетов.Колонки.Добавить("ИмяКомандыНаФорме", Новый ОписаниеТипов("Строка"));
	
	ТаблицаКоманд = КомандыОтчетов.Скопировать(,"МестоРазмещения");
	ТаблицаКоманд.Свернуть("МестоРазмещения");
	МестаРазмещения = ТаблицаКоманд.ВыгрузитьКолонку("МестоРазмещения");
	
	Для Каждого МестоРазмещения Из МестаРазмещения Цикл
		НайденныеКоманды = КомандыОтчетов.НайтиСтроки(Новый Структура("МестоРазмещения,СкрытаФункциональнымиОпциями", МестоРазмещения, Ложь));
		
		ЭлементФормыДляРазмещения = Форма.Элементы.Найти(МестоРазмещения);
		Если ЭлементФормыДляРазмещения = Неопределено Тогда
			ЭлементФормыДляРазмещения = МестоРазмещенияКомандПоУмолчанию;
		КонецЕсли;
		
		Если НайденныеКоманды.Количество() > 0 Тогда
			ДобавитьКомандыОтчетов(Форма, НайденныеКоманды, ЭлементФормыДляРазмещения);
		КонецЕсли;
	КонецЦикла;
	
	АдресКомандОтчетовВоВременномХранилище = "АдресКомандОтчетовВоВременномХранилище";
	КомандаФормы = Форма.Команды.Найти(АдресКомандОтчетовВоВременномХранилище);
	Если КомандаФормы = Неопределено Тогда
		КомандаФормы = Форма.Команды.Добавить(АдресКомандОтчетовВоВременномХранилище);
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(КомандыОтчетов, Форма.УникальныйИдентификатор);
	Иначе
		ОбщийСписокКомандОтчетовФормы = ПолучитьИзВременногоХранилища(КомандаФормы.Действие);
		Для Каждого КомандаОтчет Из КомандыОтчетов Цикл
			ЗаполнитьЗначенияСвойств(ОбщийСписокКомандОтчетовФормы.Добавить(), КомандаОтчет);
		КонецЦикла;
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(ОбщийСписокКомандОтчетовФормы, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКомандыОтчетов(Форма, КомандыОтчетов, Знач МестоРазмещенияКоманд = Неопределено)
	
	Если МестоРазмещенияКоманд = Неопределено Тогда
		МестоРазмещенияКоманд = Форма.КоманднаяПанель;
	КонецЕсли;
	
	ОднаКомандаОтчет = КомандыОтчетов.Количество() = 1;
	Если МестоРазмещенияКоманд.Вид = ВидГруппыФормы.Подменю Тогда
		Если ОднаКомандаОтчет Тогда
			МестоРазмещенияКоманд.Вид = ВидГруппыФормы.ГруппаКнопок;
		КонецЕсли;
	Иначе
		Если Не ОднаКомандаОтчет Тогда
			ПодменюОтчеты = Форма.Элементы.Добавить(МестоРазмещенияКоманд.Имя + "ПодменюОтчеты", Тип("ГруппаФормы"), МестоРазмещенияКоманд);
			ПодменюОтчеты.Вид = ВидГруппыФормы.Подменю;
			ПодменюОтчеты.Заголовок = НСтр("ru='Отчеты';uk='Звіти'");
			ПодменюОтчеты.Картинка = БиблиотекаКартинок.Отчеты;
			
			МестоРазмещенияКоманд = ПодменюОтчеты;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ОписаниеКомандыОтчет Из КомандыОтчетов Цикл
		НомерКоманды = ОписаниеКомандыОтчет.Владелец().Индекс(ОписаниеКомандыОтчет);
		ИмяКоманды = МестоРазмещенияКоманд.Имя + "КомандаОтчет" + НомерКоманды;
		
		КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		КомандаФормы.Действие = "Подключаемый_ВыполнитьКомандуОтчет";
		КомандаФормы.Заголовок = ОписаниеКомандыОтчет.Представление;
		КомандаФормы.ИзменяетСохраняемыеДанные = Ложь;
		КомандаФормы.Отображение = ОтображениеКнопки.Картинка;
		КомандаФормы.СочетаниеКлавиш = ОписаниеКомандыОтчет.СочетаниеКлавиш;
		КомандаФормы.Подсказка = ОписаниеКомандыОтчет.Представление;
		
		Если ЗначениеЗаполнено(ОписаниеКомандыОтчет.Картинка) Тогда
			КомандаФормы.Картинка = ОписаниеКомандыОтчет.Картинка;
		ИначеЕсли ОднаКомандаОтчет Тогда
			КомандаФормы.Картинка = БиблиотекаКартинок.Отчет;
			КомандаФормы.Отображение = ОтображениеКнопки.КартинкаИТекст;
		КонецЕсли;
		
		ОписаниеКомандыОтчет.ИмяКомандыНаФорме = ИмяКоманды;
		
		Если ЗначениеЗаполнено(ОписаниеКомандыОтчет.МестоРазмещенияКоманды) Тогда
			МестоРазмещенияКомандКоманды = МестоРазмещенияКоманд.ПодчиненныеЭлементы[ОписаниеКомандыОтчет.МестоРазмещенияКоманды];
		Иначе
			МестоРазмещенияКомандКоманды = МестоРазмещенияКоманд;
		КонецЕсли;
		
		ИмяЭлементаФормы = ИмяКоманды + "_" + СтрЗаменить(ОписаниеКомандыОтчет.Идентификатор,".", "_");
		
		НовыйЭлемент = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("КнопкаФормы"), МестоРазмещенияКомандКоманды);
		НовыйЭлемент.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
	КонецЦикла;
	
КонецПроцедуры

Функция КомандыОтчетовФормы(Форма, СписокОбъектов = Неопределено, ИмяМетодаМенеджераОтчеты) Экспорт
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		ИмяФормы = Форма.ИмяФормы;
	Иначе
		ИмяФормы = Форма;
	КонецЕсли;
	
	КомандыОтчетов = СоздатьКоллекциюКомандОтчетов();
	КомандыОтчетов.Колонки.Добавить("СкрытаФункциональнымиОпциями", Новый ОписаниеТипов("Булево"));
	
	СтандартнаяОбработка = Истина;
	МенюОтчетыПереопределяемый.ПередДобавлениемКомандОтчетов(ИмяФормы, КомандыОтчетов, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяФормы);
		Если ОбъектМетаданных <> Неопределено Тогда
			ОбъектМетаданных = ОбъектМетаданных.Родитель();
		КонецЕсли;
		
		Если СписокОбъектов <> Неопределено Тогда
			ЗаполнитьКомандыОтчетовДляСпискаОбъектов(СписокОбъектов, КомандыОтчетов, ИмяМетодаМенеджераОтчеты);
		ИначеЕсли ОбъектМетаданных = Неопределено Тогда
			Возврат КомандыОтчетов;
		Иначе
			КомандыДобавлены = ДобавитьКомандыИзМенеджераОтчет(ОбъектМетаданных, КомандыОтчетов, ИмяМетодаМенеджераОтчеты);
			Если ОбщегоНазначения.ЭтоЖурналДокументов(ОбъектМетаданных) Тогда
				ЗаполнитьКомандыОтчетовДляСпискаОбъектов(ОбъектМетаданных.РегистрируемыеДокументы, КомандыОтчетов, ИмяМетодаМенеджераОтчеты);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	КомандыОтчетов.Сортировать("Порядок Возр, Представление Возр");
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".", Истина, Истина);
	КраткоеИмяФормы = ЧастиИмени[ЧастиИмени.Количество()-1];
	
	// фильтр по именам форм
	Для НомерСтроки = -КомандыОтчетов.Количество() + 1 По 0 Цикл
		КомандаОтчет = КомандыОтчетов[-НомерСтроки];
		СписокФорм = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КомандаОтчет.СписокФорм, ",", Истина, Истина);
		Если СписокФорм.Количество() > 0 И СписокФорм.Найти(КраткоеИмяФормы) = Неопределено Тогда
			КомандыОтчетов.Удалить(КомандаОтчет);
		КонецЕсли;
	КонецЦикла;
	
	ОпределитьВидимостьКомандОтчетовПоФункциональнымОпциям(КомандыОтчетов, Форма);
	
	Возврат КомандыОтчетов;
	
КонецФункции

Функция СоздатьКоллекциюКомандОтчетов() Экспорт
	
	Результат = Новый ТаблицаЗначений;
	
	// описание
	Результат.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//////////
	// Опции (необязательные параметры).
	
	// менеджер создать на основании
	Результат.Колонки.Добавить("ТипыОбъектовСозданияНаОсновании", Новый ОписаниеТипов("Массив"));
	Результат.Колонки.Добавить("ИмяМетодаМенеджераОтчеты", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяСписка", Новый ОписаниеТипов("Строка"));
	
	// Альтернативный обработчик команды.
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// представление
	Результат.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	// Имена форм для размещения команд, разделитель - запятая.
	Результат.Колонки.Добавить("СписокФорм", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("МестоРазмещения", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("МестоРазмещенияКоманды", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗаголовокФормы", Новый ОписаниеТипов("Строка"));
	// Имена функциональных опций, влияющих на видимость команды, разделитель - запятая.
	Результат.Колонки.Добавить("ФункциональныеОпции", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("РежимИспользованияПараметра", Новый ОписаниеТипов("РежимИспользованияПараметраКоманды"));
	
	// проверка проведения
	Результат.Колонки.Добавить("ПроверкаПроведенияПередОтчетом", Новый ОписаниеТипов("Булево"));
	
	// дополнительные параметры
	Результат.Колонки.Добавить("ДополнительныеПараметры", Новый ОписаниеТипов("Структура"));
	
	// параметры формы отчета
	Результат.Колонки.Добавить("ПараметрыФормы", Новый ОписаниеТипов("Структура"));
	
	// Опциональное Имя формы отчета
	Результат.Колонки.Добавить("ИмяФормыОтчета", Новый ОписаниеТипов("Строка"));
	
	Результат.Колонки.Добавить("СочетаниеКлавиш", Новый ОписаниеТипов("СочетаниеКлавиш"));
	
	// Специальный режим выполнения команды
	// по умолчанию не выполняется запись модифицированного объекта перед выполнением команды.
	Результат.Колонки.Добавить("ВыполнятьЗаписьВФорме", Новый ОписаниеТипов("Булево"));
	
	Возврат Результат;
	
КонецФункции

// Устанавливает свойство видимость для элемента формы
Процедура УстановитьВидимостьЭлементаФормыСервер(Форма, ПолноеИмяЭлемента, Видимость) Экспорт
	
	Для каждого ТекЭлемент Из Форма.Элементы Цикл
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекЭлемент.Имя, "_");
		МассивПодстрок.Удалить(0);
		
		ИмяЭлемента = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивПодстрок, "_");
		ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_", ".");
		
		Если ИмяЭлемента = ПолноеИмяЭлемента Тогда
			ТекЭлемент.Видимость = Видимость;
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьКомандыОтчетовДляСпискаОбъектов(СписокОбъектов, КомандыОтчетов, ИмяМетодаМенеджераОтчеты)
	Для Каждого ОбъектМетаданных Из СписокОбъектов Цикл
		Если ОбъектМетаданных.ОсновнаяФормаСписка = Неопределено Тогда
			Продолжить; // Не предусмотрены команды создать на основании в основной форме списка объекта.
		КонецЕсли;
		ИмяФормыСписка = ОбъектМетаданных.ОсновнаяФормаСписка.ПолноеИмя();
		КомандыОтчетовФормы = МенюОтчетыПовтИсп.КомандыОтчетовФормы(ИмяФормыСписка,,ИмяМетодаМенеджераОтчеты).Скопировать();
		Для Каждого ДобавляемаяКомандаОтчет Из КомандыОтчетовФормы Цикл
			// Поиск аналогичной ранее добавленной команды создать на основании.
			СтруктураОтбора = "Идентификатор,Обработчик";
			
			Отбор = Новый Структура(СтруктураОтбора);
			ЗаполнитьЗначенияСвойств(Отбор, ДобавляемаяКомандаОтчет);
			НайденныеКоманды = КомандыОтчетов.НайтиСтроки(Отбор);
			Если НайденныеКоманды.Количество() > 0 Тогда
				Для Каждого ИмеющаясяКомандаОтчет Из НайденныеКоманды Цикл
					// Если уже есть такая команда, дополняем список типов объектов, для которых она предназначена.
					ТипОбъекта = Тип(СтрЗаменить(ОбъектМетаданных.ПолноеИмя(), ".", "Ссылка."));
					Если ИмеющаясяКомандаОтчет.ТипыОбъектовСозданияНаОсновании.Найти(ТипОбъекта) = Неопределено Тогда
						ИмеющаясяКомандаОтчет.ТипыОбъектовСозданияНаОсновании.Добавить(ТипОбъекта);
					КонецЕсли;
				КонецЦикла;
				Продолжить;
			КонецЕсли;
			
			Если ДобавляемаяКомандаОтчет.ТипыОбъектовСозданияНаОсновании.Количество() = 0 Тогда
				ДобавляемаяКомандаОтчет.ТипыОбъектовСозданияНаОсновании.Добавить(Тип(СтрЗаменить(ОбъектМетаданных.ПолноеИмя(), ".", "Ссылка.")));
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КомандыОтчетов.Добавить(), ДобавляемаяКомандаОтчет);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция ДобавитьКомандыИзМенеджераОтчет(ОбъектМетаданных, КомандыОтчетов, ИмяМетодаМенеджераОтчеты)
	ДобавляемыеКомандыОтчеты = СоздатьКоллекциюКомандОтчетов();
	
	Параметры = Новый Массив();
	Параметры.Добавить(ДобавляемыеКомандыОтчеты);
	
	МенеджерСозданияНаОсновании = ИмяБазовогоТипаПоОбъектуМетаданных(ОбъектМетаданных) + "." + ОбъектМетаданных.Имя + "." +ИмяМетодаМенеджераОтчеты;
	
	Попытка
		РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(МенеджерСозданияНаОсновании, Параметры);
	Исключение
		Если ДобавляемыеКомандыОтчеты.Количество() > 0 Тогда
			ВызватьИсключение;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецПопытки;
	
	Для Каждого КомандаОтчет Из ДобавляемыеКомандыОтчеты Цикл
		ЗаполнитьЗначенияСвойств(КомандыОтчетов.Добавить(), КомандаОтчет);
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

Процедура ОпределитьВидимостьКомандОтчетовПоФункциональнымОпциям(КомандыОтчетов, Форма)
	Для НомерКоманды = -КомандыОтчетов.Количество() + 1 По 0 Цикл
		ОписаниеКомандыОтчет = КомандыОтчетов[-НомерКоманды];
		ФункциональныеОпцииКомандыОтчет = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОписаниеКомандыОтчет.ФункциональныеОпции, ",", Истина);
		ВидимостьКоманды = ФункциональныеОпцииКомандыОтчет.Количество() = 0;
		Для Каждого ФункциональнаяОпция Из ФункциональныеОпцииКомандыОтчет Цикл
			Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
				ВидимостьКоманды = ВидимостьКоманды Или Форма.ПолучитьФункциональнуюОпциюФормы(ФункциональнаяОпция);
			Иначе
				ВидимостьКоманды = ВидимостьКоманды Или ПолучитьФункциональнуюОпцию(ФункциональнаяОпция);
			КонецЕсли;
			
			Если ВидимостьКоманды Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ОписаниеКомандыОтчет.СкрытаФункциональнымиОпциями = Не ВидимостьКоманды;
	КонецЦикла;
КонецПроцедуры

Функция ПредставлениеОбъекта(ПараметрОбъект) Экспорт
	
	Если ПараметрОбъект = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	МетаданныеОбъекта = ?(ТипЗнч(ПараметрОбъект) = Тип("Строка"), Метаданные.НайтиПоПолномуИмени(ПараметрОбъект), ПараметрОбъект);
	
	Представление = Новый Структура("ПредставлениеОбъекта");
	ЗаполнитьЗначенияСвойств(Представление, МетаданныеОбъекта);
	Если Не ПустаяСтрока(Представление.ПредставлениеОбъекта) Тогда
		Возврат Представление.ПредставлениеОбъекта;
	КонецЕсли;
	
	Возврат МетаданныеОбъекта.Представление();
КонецФункции

Функция ОписаниеКомандыОтчет(ИмяКоманды, АдресКомандОтчетовВоВременномХранилище) Экспорт
	
	КомандыОтчетов = ПолучитьИзВременногоХранилища(АдресКомандОтчетовВоВременномХранилище);
	Для Каждого КомандаОтчет Из КомандыОтчетов.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаОтчет);
	КонецЦикла;
	
КонецФункции

Функция ДоступноПравоПроведения(СписокДокументов) Экспорт
	ТипыДокументов = Новый Массив;
	Для Каждого Документ Из СписокДокументов Цикл
		ТипДокумента = ТипЗнч(Документ);
		Если ТипыДокументов.Найти(ТипДокумента) <> Неопределено Тогда
			Продолжить;
		Иначе
			ТипыДокументов.Добавить(ТипДокумента);
		КонецЕсли;
		Если ПравоДоступа("Проведение", Метаданные.НайтиПоТипу(ТипДокумента)) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Процедура УдалитьКоманды(Форма, МестоРазмещенияКомандПоУмолчанию)
	
	МассивКоманд = Новый Массив;
	Для каждого Команда Из Форма.Команды Цикл
		Если Команда.Действие = "Подключаемый_ВыполнитьКомандуОтчет" Тогда
			МассивКоманд.Добавить(Команда);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Команда Из МассивКоманд Цикл
		Форма.Команды.Удалить(Команда);
	КонецЦикла; 
	
	МассивЭлементовДляУдаления = Новый Массив;
	Если МестоРазмещенияКомандПоУмолчанию <> Неопределено Тогда
		МассивЭлементовДляУдаления = ПолучитьПодчиненныеЭлементы(МестоРазмещенияКомандПоУмолчанию.ПодчиненныеЭлементы, МассивЭлементовДляУдаления);
	КонецЕсли;
	
	Для Каждого Элемент Из МассивЭлементовДляУдаления Цикл
		Попытка
			Форма.Элементы.Удалить(Элемент);
		Исключение
		КонецПопытки;
	КонецЦикла; 
	
КонецПроцедуры

Функция ИмяБазовогоТипаПоОбъектуМетаданных(ОбъектМетаданных) Экспорт
	
	Если Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаДокументы();
		
	ИначеЕсли Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаСправочники();
		
	ИначеЕсли Метаданные.Перечисления.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПеречисления();
		
	ИначеЕсли Метаданные.Обработки.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаОбработки();
		
	ИначеЕсли Метаданные.Отчеты.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаОтчеты();
		
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаРегистрыСведений();
		
	ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаРегистрыНакопления();
		
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаРегистрыБухгалтерии();
		
	ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаРегистрыРасчета();
		
	ИначеЕсли Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПланыОбмена();
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПланыВидовХарактеристик();
		
	ИначеЕсли Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаБизнесПроцессы();
		
	ИначеЕсли Метаданные.Задачи.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаЗадачи();
		
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПланыСчетов();
		
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПланыВидовРасчета();
		
	ИначеЕсли Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаКонстанты();
		
	ИначеЕсли Метаданные.ЖурналыДокументов.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаЖурналыДокументов();
		
	ИначеЕсли Метаданные.Последовательности.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаПоследовательности();
		
	ИначеЕсли Метаданные.РегламентныеЗадания.Содержит(ОбъектМетаданных) Тогда
		Возврат ОбщегоНазначения.ИмяТипаРегламентныеЗадания();
		
	ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных.Родитель())
		И ОбъектМетаданных.Родитель().Перерасчеты.Найти(ОбъектМетаданных.Имя) = ОбъектМетаданных Тогда
		Возврат ОбщегоНазначения.ИмяТипаПерерасчеты();
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПодчиненныеЭлементы(ГруппаЭлементов, МассивЭлементов)

	Для Каждого Элемент Из ГруппаЭлементов Цикл
		
		Если Элемент.Вид = ВидГруппыФормы.ГруппаКнопок Тогда
			ПолучитьПодчиненныеЭлементы(Элемент.ПодчиненныеЭлементы, МассивЭлементов);
		Иначе
			МассивЭлементов.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат МассивЭлементов

КонецФункции

#КонецОбласти

