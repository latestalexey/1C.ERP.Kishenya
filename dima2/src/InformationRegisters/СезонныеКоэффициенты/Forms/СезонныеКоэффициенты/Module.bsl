&НаКлиенте
Перем ПередЗаписьюПовторныйВызов; // Используется для не модальных вопросов перед записью
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;
&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СезонныеГруппыБизнесРегионов.Ссылка) КАК КоличествоСсылок
	|ИЗ
	|	Справочник.СезонныеГруппыБизнесРегионов КАК СезонныеГруппыБизнесРегионов";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.КоличествоСсылок <= 1 И СезонныеГруппыБизнесРегионов.Количество() = 0 Тогда
		СезонныеГруппыБизнесРегионов.Добавить(ПредопределенноеЗначение("Справочник.СезонныеГруппыБизнесРегионов.Прочие"));
	КонецЕсли; 
	
	Периодичность = Константы.ПериодичностьВводаСезонныхКоэффициентов.Получить();
	
	АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ТипДиаграммыКоэффициентов = Перечисления.ТипыДиаграммПоказателей.График;
	
	Если Параметры.ТолькоПросмотр ИЛИ НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СезонныеКоэффициенты) Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	Элементы.СезонныеКоэффициентыИзменить.Доступность = НЕ ЭтаФорма.ТолькоПросмотр;
	Элементы.СезонныеКоэффициентыСоздать.Доступность = ПравоДоступа("Добавление", Метаданные.Справочники.СезонныеГруппы);
	
	Если ТипЗнч(Параметры.СезонныеГруппы) = Тип("Массив") Тогда
	
		СезонныеГруппы.ЗагрузитьЗначения(Параметры.СезонныеГруппы);
		
	ИначеЕсли ТипЗнч(Параметры.СезонныеГруппы) = Тип("СписокЗначений") Тогда
	
		СезонныеГруппы.ЗагрузитьЗначения(Параметры.СезонныеГруппы.ВыгрузитьЗначения());
		
	ИначеЕсли ТипЗнч(Параметры.СезонныеГруппы) = Тип("СправочникСписок.СезонныеГруппы") Тогда
	
		СезонныеГруппы.Добавить(Параметры.СезонныеГруппы);
		
	КонецЕсли; 
	
	Планирование.СоздатьТаблицуПериодов(ЭтаФорма, "Периоды");
	
	ТаблицаПериоды = РеквизитФормыВЗначение("Периоды", Тип("ТаблицаЗначений"));
	
	Планирование.ЗаполнитьТаблицуПериодов(ТаблицаПериоды, 
		Периодичность, 
		Дата("00010101"), 
		Дата("00011231235959"), 
		Периодичность <> Перечисления.Периодичность.Неделя);
	
	Если Периодичность = Перечисления.Периодичность.Неделя Тогда
	
		НайденныеСтроки = ТаблицаПериоды.НайтиСтроки(Новый Структура("ДатаНачала", Дата("00011231000000")));
		Если НайденныеСтроки.Количество() > 0 Тогда
		
			Период = НайденныеСтроки[0];
			Период.Заголовок = НСтр("ru='31.12';uk='31.12'");
		
		КонецЕсли; 
	КонецЕсли; 
	
	ЗначениеВРеквизитФормы(ТаблицаПериоды,"Периоды");
	
	ПараметрыВывода = Новый Структура;
	ПараметрыВывода.Вставить("ИмяРеквизитаКроссТаблицы", "СезонныеКоэффициенты");
	ПараметрыВывода.Вставить("ЭлементФормыКроссТаблицы", "СезонныеКоэффициенты");
	ПараметрыВывода.Вставить("ТаблицаПериодов", ТаблицаПериоды);
	ПараметрыВывода.Вставить("Периодичность", Периодичность);
	
	ПараметрыВывода.Вставить("ГруппироватьПоля", Ложь);
	ПараметрыВывода.Вставить("ЗаголовокПоляГруппировки", НСтр("ru='Периоды планирования';uk='Періоди планування'"));
	
	ПараметрыВывода.Вставить("Поля", Новый Массив());
	
	СтруктураПоля = Новый Структура;
	СтруктураПоля.Вставить("ПрефиксРеквизитаКолонки", "Коэффициент_");
	СтруктураПоля.Вставить("УдалятьРеквизитыТаблицы", Ложь);
	СтруктураПоля.Вставить("СоздаватьЭлемент", Истина);
	СтруктураПоля.Вставить("ТипЭлемента", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15, 3));
	СтруктураПоля.Вставить("СоздаватьИтоговыеРеквизиты", Ложь);
	СтруктураПоля.Вставить("ШиринаЭлемента", 6);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПриИзменении", "Подключаемый_СезонныеКоэффициентыПриИзмененииКоэффициента");
	СтруктураПоля.Вставить("СтруктураДействий", СтруктураДействий);
	
	ПараметрыВывода.Поля.Добавить(СтруктураПоля);
	
	Планирование.ОбновитьСтруктуруВыводаКроссТаблицы(ЭтаФорма, ПараметрыВывода);
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Периодичность) Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(,НСтр("ru='Не указана настройка ""Периодичность указания сезонных коэффициентов"" в разделе Администрирование - Продажи.';uk='Не зазначена настройка ""Періодичність зазначення сезонних коефіцієнтів"" в розділі Адміністрування - Продажі.'"));
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПередЗаписьюПовторныйВызов = Истина Тогда
		ПередЗаписьюПовторныйВызов = Ложь;
		Возврат;
	КонецЕсли; 
	
	Если Модифицированность Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Сохранить';uk='Зберегти'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Не сохранять';uk='Не зберігати'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			НСтр("ru='Коэффциенты были изменены. Сохранить изменения?';uk='Коефіцієнти були змінені. Зберегти зміни?'"),
			Кнопки);
		
		Отказ = Истина;
		ПередЗаписьюПовторныйВызов = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СезонныеГруппыПриИзменении(Элемент)
	
	Если Модифицированность Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать и обновить';uk='Записати і оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Обновить';uk='Оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Не обновлять';uk='Не оновлювати'"));
		
		Оповещение = Новый ОписаниеОповещения("СезонныеГруппыПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			НСтр("ru='Коэффциенты были изменены. Записать изменения и обновить?';uk='Коефіцієнти були змінені. Записати зміни і оновити?'"),
			Кнопки);
		
	Иначе
	
		ЗаполнитьНаСервере();
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаГрафик Тогда
	
		ГрафикНаСервере();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДиаграммыПриИзменении(Элемент)
	
	ТипДиаграммыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДанныхПриИзменении(Элемент)
	
	ГрафикНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура График(Команда)
	
	ГрафикНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если Модифицированность Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Обновить';uk='Оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Не обновлять';uk='Не оновлювати'"));
		
		Оповещение = Новый ОписаниеОповещения("ОбновитьЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			НСтр("ru='Коэффциенты были изменены. При обновлении данные не будут сохранены. Обновить?';uk='Коефіцієнти були змінені. При оновленні дані не будуть збережені. Оновити?'"),
			Кнопки);
		
	Иначе
	
		ЗаполнитьНаСервере();
	
	КонецЕсли; 
	
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПоСтатистике(Команда)
	
	Если Элементы.СезонныеКоэффициенты.ВыделенныеСтроки.Количество() = 0 Тогда
	
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выделить строки для расчета по статистике продаж.';uk='Необхідно виділити рядки для розрахунку за статистикою продажів.'"));
		Возврат;
	
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("РассчитатьПоСтатистикеЗавершение",ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Периодичность", Периодичность);
	ПараметрыФормы.Вставить("АдресПользовательскихНастроек", АдресПользовательскихНастроек);
	
	ОткрытьФорму("РегистрСведений.СезонныеКоэффициенты.Форма.ФормаПериода",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	ФормаОбъекта = ОткрытьФорму("Справочник.СезонныеГруппы.ФормаОбъекта", 
		, 
		ЭтаФорма, 
		УникальныйИдентификатор,
		,
		,
		, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ФормаОбъекта", ФормаОбъекта);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ФормаОбъекта.ОписаниеОповещенияОЗакрытии = Оповещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоГруппам(Команда)
	
	Если Модифицированность Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать и обновить';uk='Записати і оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Обновить';uk='Оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Не обновлять';uk='Не оновлювати'"));
		
		Оповещение = Новый ОписаниеОповещения("ОтобратьПоГруппамЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			НСтр("ru='Коэффциенты были изменены. Записать изменения и обновить?';uk='Коефіцієнти були змінені. Записати зміни і оновити?'"),
			Кнопки);
		
	Иначе
		
		СезонныеГруппы.Очистить();
		
		Для каждого ВыбраннаяСтрока Из Элементы.СезонныеКоэффициенты.ВыделенныеСтроки Цикл
		
			СтрокаТЧ = СезонныеКоэффициенты.НайтиПоИдентификатору(ВыбраннаяСтрока);
			Если СтрокаТЧ <> Неопределено И ЗначениеЗаполнено(СтрокаТЧ.СезоннаяГруппа) Тогда
			
				СезонныеГруппы.Добавить(СтрокаТЧ.СезоннаяГруппа);
			
			КонецЕсли; 
		
		КонецЦикла; 
		ЗаполнитьНаСервере();
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СезонныеКоэффициентыСезоннаяГруппаБизнесРегиона.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СезонныеКоэффициенты.СезоннаяГруппаБизнесРегиона");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Справочник.СезонныеГруппыБизнесРегионов.Прочие");

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ИспользоватьБизнесРегионы = ПолучитьФункциональнуюОпцию("ИспользоватьБизнесРегионы");
	
	Элементы.СезонныеГруппыБизнесРегионов.Видимость                    = ИспользоватьБизнесРегионы;
	Элементы.СезонныеКоэффициентыСезоннаяГруппаБизнесРегиона.Видимость = ИспользоватьБизнесРегионы
	                                                                   И КоличествоГруппБизнесРегионов > 1;
КонецПроцедуры

&НаСервере
Процедура ГрафикНаСервере()
	
	ИмяТипаДиаграммы = МониторингЦелевыхПоказателей.ПолучитьИмяЗначенияПеречисления(ТипДиаграммыКоэффициентов);
	Диаграмма.ТипДиаграммы = ТипДиаграммы[ИмяТипаДиаграммы];
	Диаграмма.РежимСглаживания = РежимСглаживанияДиаграммы.ГладкаяКривая;
	
	Если ТипДанных = 1 Тогда
		
		ИсточникДанных = ПолучитьНомированныеКоэффициенты();
	
	Иначе
	
		ИсточникДанных = СезонныеКоэффициенты.Выгрузить();
	
	КонецЕсли; 
	
	ИсточникДанных.Колонки.Вставить(0, "Заголовок");
	
	Для Каждого Источник Из ИсточникДанных Цикл
		
		Источник.Заголовок = Строка(Источник.СезоннаяГруппа)
			+ ?(КоличествоГруппБизнесРегионов > 1, 
				"; " + Строка(Источник.СезоннаяГруппаБизнесРегиона), "");
	
	КонецЦикла; 
	
	ИсточникДанных.Колонки.Удалить("СезоннаяГруппа");
	ИсточникДанных.Колонки.Удалить("СезоннаяГруппаБизнесРегиона");
	
	Диаграмма.ИсточникДанных = ИсточникДанных;
	
	Для каждого Серия Из Диаграмма.Серии Цикл
	
		Серия.Маркер = ТипМаркераДиаграммы.Нет;
	
	КонецЦикла; 
	
	Для каждого Точка Из Диаграмма.Точки Цикл
		
		Индекс = Диаграмма.Точки.Индекс(Точка);
		НайденныеСтроки = ЭтаФорма.Периоды.НайтиСтроки(Новый Структура("Активная, НомерКолонки", Истина, Индекс + 1));
		Если НайденныеСтроки.Количество() > 0 Тогда
		
			Точка.Текст = НайденныеСтроки[0].Заголовок;
		
		КонецЕсли; 
	
	КонецЦикла;
	
	Диаграмма.ОбластьПостроения.ОтображатьПодписиШкалыЗначений = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНомированныеКоэффициенты()
	
	НомированныеКоэфффициенты = СезонныеКоэффициенты.Выгрузить();
	
	КоличествоПериодов = ЭтаФорма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина)).Количество();
	
	Для каждого СтрокаТЧ Из НомированныеКоэфффициенты Цикл
		
		СуммаКоэффициентов = 0;
		
		Для каждого Период Из ЭтаФорма.Периоды Цикл
			Если НЕ Период.Активная Тогда
				Продолжить;
			КонецЕсли; 
			
			СуммаКоэффициентов = СуммаКоэффициентов + СтрокаТЧ["Коэффициент_" + Период.ИмяКолонки];
		
		КонецЦикла; 
		
		Если СуммаКоэффициентов = 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		СреднийКоэффициент = СуммаКоэффициентов / КоличествоПериодов;
		
		Для каждого Период Из ЭтаФорма.Периоды Цикл
			Если НЕ Период.Активная Тогда
				Продолжить;
			КонецЕсли; 
			
			СтрокаТЧ["Коэффициент_" + Период.ИмяКолонки] =  СтрокаТЧ["Коэффициент_" + Период.ИмяКолонки] / СреднийКоэффициент;
		
		КонецЦикла; 
	
	КонецЦикла; 
	
	Возврат НомированныеКоэфффициенты;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ЗаполнитьНаСервере();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СезонныеГруппыПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ЗаписатьИОбновитьНаСервере();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
	
		ЗаполнитьНаСервере();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоГруппамЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да ИЛИ Результат = КодВозвратаДиалога.Нет Тогда
		
		СезонныеГруппы.Очистить();
		
		Для каждого ВыбраннаяСтрока Из Элементы.СезонныеКоэффициенты.ВыделенныеСтроки Цикл
		
			СтрокаТЧ = СезонныеКоэффициенты.НайтиПоИдентификатору(ВыбраннаяСтрока);
			Если СтрокаТЧ <> Неопределено И ЗначениеЗаполнено(СтрокаТЧ.СезоннаяГруппа) Тогда
			
				СезонныеГруппы.Добавить(СтрокаТЧ.СезоннаяГруппа);
			
			КонецЕсли; 
		
		КонецЦикла;
	
	КонецЕсли; 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ЗаписатьИОбновитьНаСервере();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
	
		ЗаполнитьНаСервере();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	СезоннаяГруппа = ПараметрыОповещения.ФормаОбъекта.Объект.Ссылка;
	
	Если Не ЗначениеЗаполнено(СезоннаяГруппа) Тогда
		Возврат;
	КонецЕсли;
	
	Если СезонныеГруппы.Количество() > 0 Тогда
	
		СезонныеГруппы.Добавить(СезоннаяГруппа);
	
	КонецЕсли;
	
	НоваяСтрока = СезонныеКоэффициенты.Добавить();
	НоваяСтрока.СезоннаяГруппа = СезоннаяГруппа;
	
	ПараметрыОповещения.ФормаОбъекта = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ЗаписатьНаСервере();
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
	
		Закрыть();
		
	Иначе
		
		ПередЗаписьюПовторныйВызов = Ложь;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИОбновитьНаСервере()

	ЗаписатьНаСервере();
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ИспользоватьБизнесРегионы = ПолучитьФункциональнуюОпцию("ИспользоватьБизнесРегионы");
	Если Не ИспользоватьБизнесРегионы Тогда
	
		СезонныеГруппыБизнесРегионов.Очистить();
		СезонныеГруппыБизнесРегионов.Добавить(Справочники.СезонныеГруппыБизнесРегионов.Прочие);
	
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СезонныеГруппы.Ссылка КАК СезоннаяГруппа,
	|	СезонныеГруппыБизнесРегионов.Ссылка КАК СезоннаяГруппаБизнесРегиона,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоГода, НЕДЕЛЯ, СезонныеКоэффициенты.НомерПериода - 1)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоГода, МЕСЯЦ, СезонныеКоэффициенты.НомерПериода - 1)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоГода, КВАРТАЛ, СезонныеКоэффициенты.НомерПериода - 1)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоГода, ГОД, СезонныеКоэффициенты.НомерПериода - 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачалоГода, ДЕНЬ, СезонныеКоэффициенты.НомерПериода - 1)
	|	КОНЕЦ КАК Период,
	|	ЕСТЬNULL(СезонныеКоэффициенты.Коэффициент, 0) КАК Коэффициент
	|ИЗ
	|	Справочник.СезонныеГруппы КАК СезонныеГруппы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СезонныеГруппыБизнесРегионов КАК СезонныеГруппыБизнесРегионов
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СезонныеКоэффициенты КАК СезонныеКоэффициенты
	|		ПО (СезонныеКоэффициенты.Периодичность = &Периодичность)
	|			И СезонныеГруппы.Ссылка = СезонныеКоэффициенты.СезоннаяГруппа
	|			И (СезонныеГруппыБизнесРегионов.Ссылка = СезонныеКоэффициенты.СезоннаяГруппаБизнесРегиона)
	|ГДЕ
	|	1 = 1
	|	%ДополнительныОтбор%
	|
	|УПОРЯДОЧИТЬ ПО
	|	СезонныеГруппы.Наименование,
	|	СезонныеГруппыБизнесРегионов.Наименование,
	|	Период
	|ИТОГИ ПО
	|	СезоннаяГруппа,
	|	СезоннаяГруппаБизнесРегиона";
	
	ТекстОтбора = "";
	
	Запрос.УстановитьПараметр("НачалоГода", Дата("00010101"));
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	ЗаполнятьОтборСезонныхГрупп = Ложь;
	
	Если СезонныеГруппы.Количество() > 0 Тогда
	
		ТекстОтбора = ТекстОтбора + " И СезонныеГруппы.Ссылка В(&СезонныеГруппы)";
		Запрос.УстановитьПараметр("СезонныеГруппы", СезонныеГруппы);
		ЗаполнятьОтборСезонныхГрупп = Истина;
	
	КонецЕсли; 
	
	ЗаполнятьОтборСезонныхГруппБизнесРегионов = Ложь;
	
	Если СезонныеГруппыБизнесРегионов.Количество() > 0 Тогда
	
		ТекстОтбора = ТекстОтбора + " И СезонныеГруппыБизнесРегионов.Ссылка В(&СезонныеГруппыБизнесРегионов)";
		Запрос.УстановитьПараметр("СезонныеГруппыБизнесРегионов", СезонныеГруппыБизнесРегионов);
		ЗаполнятьОтборСезонныхГруппБизнесРегионов = Истина;
		
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ДополнительныОтбор%", ТекстОтбора);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаСезоннаяГруппа = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	СезонныеКоэффициенты.Очистить();
	СезонныеГруппы.Очистить();
	СезонныеГруппыБизнесРегионов.Очистить();
	
	КоличествоГруппБизнесРегионов = 0;
	
	Пока ВыборкаСезоннаяГруппа.Следующий() Цикл
		
		Если ЗаполнятьОтборСезонныхГрупп Тогда
		
			СезонныеГруппы.Добавить(ВыборкаСезоннаяГруппа.СезоннаяГруппа);
		
		КонецЕсли;
		
		ВыборкаСезоннаяГруппаБизнесРегиона = ВыборкаСезоннаяГруппа.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСезоннаяГруппаБизнесРегиона.Следующий() Цикл
			
			Если ЗаполнятьОтборСезонныхГруппБизнесРегионов Тогда
				ГруппаБизнесРегиона = ВыборкаСезоннаяГруппаБизнесРегиона.СезоннаяГруппаБизнесРегиона;
				Если СезонныеГруппыБизнесРегионов.НайтиПоЗначению(ГруппаБизнесРегиона) = Неопределено Тогда
					СезонныеГруппыБизнесРегионов.Добавить(ГруппаБизнесРегиона);
				КонецЕсли; 
				
			КонецЕсли;
			
			КоличествоГруппБизнесРегионов = ВыборкаСезоннаяГруппаБизнесРегиона.Количество();
			
			НоваяСтрока = СезонныеКоэффициенты.Добавить();
			
			ВыборкаДетальныеЗаписи = ВыборкаСезоннаяГруппаБизнесРегиона.Выбрать();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаСезоннаяГруппаБизнесРегиона);

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Отбор = Новый Структура("Активная, ДатаНачала", Истина, ВыборкаДетальныеЗаписи.Период); 
				НайденныеСтроки = ЭтаФорма.Периоды.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					
					НоваяСтрока["Коэффициент_" + НайденныеСтроки[0].ИмяКолонки] = ВыборкаДетальныеЗаписи.Коэффициент;
					
				КонецЕсли; 
			КонецЦикла;
			
		КонецЦикла; 
		
	КонецЦикла;
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаГрафик Тогда
	
		ГрафикНаСервере();
	
	КонецЕсли; 
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ТипДиаграммыПриИзмененииНаСервере()
	
	ИмяТипаДиаграммы = МониторингЦелевыхПоказателей.ПолучитьИмяЗначенияПеречисления(ТипДиаграммыКоэффициентов);
	Диаграмма.ТипДиаграммы = ТипДиаграммы[ИмяТипаДиаграммы];
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(Отказ = Ложь)
	
	НаборЗаписей = РегистрыСведений.СезонныеКоэффициенты.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Периодичность.Установить(Периодичность);
	
	НаборЗаписейДень = РегистрыСведений.СезонныеКоэффициенты.СоздатьНаборЗаписей();
	НаборЗаписейДень.Отбор.Периодичность.Установить(Перечисления.Периодичность.День);
	
	Для каждого СтрокаТЧ Из СезонныеКоэффициенты Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.СезоннаяГруппа) Тогда
			Продолжить;
		КонецЕсли; 
		
		НаборЗаписей.Отбор.СезоннаяГруппа.Установить(СтрокаТЧ.СезоннаяГруппа);
		НаборЗаписей.Отбор.СезоннаяГруппаБизнесРегиона.Установить(СтрокаТЧ.СезоннаяГруппаБизнесРегиона);
		НаборЗаписей.Очистить();
		
		НаборЗаписейДень.Отбор.СезоннаяГруппа.Установить(СтрокаТЧ.СезоннаяГруппа);
		НаборЗаписейДень.Отбор.СезоннаяГруппаБизнесРегиона.Установить(СтрокаТЧ.СезоннаяГруппаБизнесРегиона);
		НаборЗаписейДень.Очистить();
		
		Для каждого Период Из ЭтаФорма.Периоды Цикл
			Если НЕ Период.Активная Тогда
				Продолжить;
			КонецЕсли;
			
			РСЗапись = НаборЗаписей.Добавить();
			РСЗапись.Периодичность               = Периодичность;
			РСЗапись.СезоннаяГруппа              = СтрокаТЧ.СезоннаяГруппа;
			РСЗапись.СезоннаяГруппаБизнесРегиона = СтрокаТЧ.СезоннаяГруппаБизнесРегиона;
			РСЗапись.НомерПериода                = Период.НомерКолонки;
			РСЗапись.Коэффициент                 = СтрокаТЧ["Коэффициент_" + Период.ИмяКолонки];
			
			НомерПериода = ДеньГода(Период.ДатаНачала);
			
			КоличествоДней = 1;
			Если Периодичность = Перечисления.Периодичность.Месяц Тогда
				КоличествоДней = (Период.ДатаОкончания + 1 - Период.ДатаНачала) / 86400;
			ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
				КоличествоДней = 7;
				Если НомерПериода + КоличествоДней > 365 Тогда
				
					КоличествоДней = 365 - НомерПериода + 1;
				
				КонецЕсли; 
				
			КонецЕсли;
			
			КоэффициентКРаспределению = СтрокаТЧ["Коэффициент_" + Период.ИмяКолонки];
			
			Для Индекс = 1 По КоличествоДней Цикл
				
				Коэффициент = КоэффициентКРаспределению / (КоличествоДней - Индекс + 1);
				
				РСЗапись = НаборЗаписейДень.Добавить();
				РСЗапись.Периодичность               = Перечисления.Периодичность.День;
				РСЗапись.СезоннаяГруппа              = СтрокаТЧ.СезоннаяГруппа;
				РСЗапись.СезоннаяГруппаБизнесРегиона = СтрокаТЧ.СезоннаяГруппаБизнесРегиона;
				РСЗапись.НомерПериода                = НомерПериода;
				РСЗапись.Коэффициент                 = Коэффициент;
				
				НомерПериода = НомерПериода + 1;
				
				КоэффициентКРаспределению = КоэффициентКРаспределению - РСЗапись.Коэффициент;
			КонецЦикла; 
			
		
		КонецЦикла; 
		
		НачатьТранзакцию();
		Попытка
			
			НаборЗаписей.Записать();
			НаборЗаписейДень.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(НСтр("ru='Запись сезонных коэффициентов';uk='Запис сезонних коефіцієнтів'"), 
			УровеньЖурналаРегистрации.Ошибка,
			,
			, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибки = НСтр("ru='Не удалось записать коэффициенты по группе: %СезоннаяГруппа%';uk='Не вдалося записати коефіцієнти по групі: %СезоннаяГруппа%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки , "%СезоннаяГруппа%", Строка(СтрокаТЧ.СезоннаяГруппа));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,"СезонныеКоэффициенты", Отказ);
			
		КонецПопытки; 
		
		
	КонецЦикла; 
	
	Если НЕ Отказ Тогда
	
		Модифицированность = Ложь;
	
	КонецЕсли; 
	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПоСтатистикеЗавершение(Настройки, ДополнительныеПараметры) Экспорт 
	
	Если Настройки <> Неопределено Тогда
		
		Результат = РассчитатьПоСтатистикеПродажНаСервере(Настройки);
		
		Если НЕ Результат.ЗаданиеВыполнено Тогда
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			АдресХранилища       = Результат.АдресХранилища;
			
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		Иначе
			КоличествоСтрок = ПолучитьРезультатРассчетаНаСервере();
			ОповеститьОбОкончанииРасчетаПоСтатистикеПродаж(Элементы.СезонныеКоэффициенты.ВыделенныеСтроки.Количество(), 
				КоличествоСтрок);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

//Унифицированная процедура проверки выполнения фонового задания
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				КоличествоСтрок = ПолучитьРезультатРассчетаНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ОповеститьОбОкончанииРасчетаПоСтатистикеПродаж(Элементы.СезонныеКоэффициенты.ВыделенныеСтроки.Количество(), 
					КоличествоСтрок);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбОкончанииРасчетаПоСтатистикеПродаж(КоличествоСтрокВсего, КоличествоСтрок)

	Текст = НСтр("ru='Обновлено: (%1) из (%2) выделенных строк';uk='Оновлено: (%1) з (%2) вибраних рядків'");
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Текст, 
		КоличествоСтрок, 
		КоличествоСтрокВсего);
	ПоказатьОповещениеПользователя(Текст);

КонецПроцедуры 
 
&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция РассчитатьПоСтатистикеПродажНаСервере(ПараметрыЗадания)
	
	ОтборСезонныеГруппы = Новый СписокЗначений;
	Для каждого Строка Из Элементы.СезонныеКоэффициенты.ВыделенныеСтроки Цикл
		СтрокаТЧ = СезонныеКоэффициенты.НайтиПоИдентификатору(Строка);
		Если ЗначениеЗаполнено(СтрокаТЧ.СезоннаяГруппа) Тогда
			ОтборСезонныеГруппы.Добавить(СтрокаТЧ.СезоннаяГруппа);
		КонецЕсли; 
	КонецЦикла; 
	
	ПараметрыЗадания.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыЗадания.Вставить("Периодичность",           Периодичность);
	ПараметрыЗадания.Вставить("КлючОбщихНастроек",       "РегистрСведений.СезонныеКоэффициенты");
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОтборСезонныеГруппы", ОтборСезонныеГруппы);
	Настройки.Вставить("ПользовательскиеНастройки", ПолучитьИзВременногоХранилища(АдресПользовательскихНастроек));
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ПараметрыЗадания.КлючОбщихНастроек, 
		"НастройкиФоновогоЗадания_"+ПараметрыЗадания.УникальныйИдентификатор, 
		Настройки);
	
	НаименованиеЗадания = НСтр("ru='Рассчет сезонных коэффициентов по статистике продаж';uk='Розрахунок сезонних коефіцієнтів за статистикою продажів'");
		
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"РегистрыСведений.СезонныеКоэффициенты.РассчитатьКоэффициентыПоСтатистикеПродаж",
		ПараметрыЗадания,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьРезультатРассчетаНаСервере()
	
	ТаблицаКоэффициентов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТаблицаКоэффициентов.Колонки.Найти("СезоннаяГруппаБизнесРегиона") = Неопределено Тогда
		
		ТаблицаКоэффициентов.Колонки.Добавить("СезоннаяГруппаБизнесРегиона");
		ТаблицаКоэффициентов.ЗаполнитьЗначения(Справочники.СезонныеГруппыБизнесРегионов.Прочие, "СезоннаяГруппаБизнесРегиона");
		
	КонецЕсли;
	
	ТаблицаКоэффициентов.Сортировать("СезоннаяГруппа, СезоннаяГруппаБизнесРегиона, Период");
	
	СезоннаяГруппа              = Неопределено;
	СезоннаяГруппаБизнесРегиона = Неопределено;
	СтрокаТЧ                    = Неопределено;
	
	КоличествоСтрок = 0;
	
	Для каждого СтрокаКоэффициентов Из ТаблицаКоэффициентов Цикл
		
		Если СезоннаяГруппа <> СтрокаКоэффициентов.СезоннаяГруппа 
				ИЛИ СезоннаяГруппаБизнесРегиона <> СтрокаКоэффициентов.СезоннаяГруппаБизнесРегиона Тогда
			
			КоличествоСтрок = КоличествоСтрок + 1;
			СезоннаяГруппа              = СтрокаКоэффициентов.СезоннаяГруппа;
			СезоннаяГруппаБизнесРегиона = СтрокаКоэффициентов.СезоннаяГруппаБизнесРегиона;
			
			НайденныеСтроки = СезонныеКоэффициенты.НайтиСтроки(Новый Структура("СезоннаяГруппа, СезоннаяГруппаБизнесРегиона", 
			                                                         СтрокаКоэффициентов.СезоннаяГруппа, СезоннаяГруппаБизнесРегиона));
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				СтрокаТЧ = НайденныеСтроки[0];
				Для каждого Период Из ЭтаФорма.Периоды Цикл
					Если НЕ Период.Активная Тогда
						Продолжить;
					КонецЕсли; 
					СтрокаТЧ["Коэффициент_"+Период.ИмяКолонки] = 0;
				КонецЦикла;
			Иначе
				СтрокаТЧ = Неопределено;
			КонецЕсли; 
		КонецЕсли;
		
		Если СтрокаТЧ = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		Отбор = Новый Структура("Активная, ДатаНачала", Истина, СтрокаКоэффициентов.Период); 
		НайденныеСтроки = ЭтаФорма.Периоды.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			СтрокаТЧ["Коэффициент_"+НайденныеСтроки[0].ИмяКолонки] = СтрокаКоэффициентов.Коэффициент;
			
		КонецЕсли;
	КонецЦикла; 
	
	Возврат КоличествоСтрок;
	
КонецФункции

#КонецОбласти

