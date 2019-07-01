&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПредупредитьОВозможнойНехваткеПрав = ПолучитьФункциональнуюОпциюФормы("ОграничиватьДоступНаУровнеЗаписей")
		И Не Пользователи.РолиДоступны("ПолныеПрава");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПредупредитьОВозможнойНехваткеПрав Тогда
		
		ТекстПредупреждения = НСтр("ru='Включено ограничение доступа на уровне записей.
            |Для успешной работы необходимо обладать полными правами на доступ к объектам.'
            |;uk='Включено обмеження доступу на рівні записів.
            |Для успішної роботи необхідно володіти повними правами на доступ до об''єктів.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
			
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтаФорма Тогда
		
		Если ИмяСобытия = "ЗавершенПодробныйПросмотрЗадвоенныхДанныхФизическихЛиц" Тогда
			
			ЗаполнитьДеревоСравненияНаСервере(Параметр.ДеревоСравнения);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНайденныеДубли

&НаКлиенте
Процедура НайденныеДублиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.ФизическоеЛицо);
КонецПроцедуры

&НаКлиенте
Процедура НайденныеДублиПослеУдаления(Элемент)
	
	НайденныеДублиПослеУдаленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеДублиОбработкаВыбора(Элемент, ВыбранныеЗначения, СтандартнаяОбработка)
	
	ДобавитьВыбранныеФизическиеЛица(ВыбранныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбъединитьИОчистить(Команда)
	
	ТекстВопроса = НСтр("ru='Операция объединения карточек с личными данными является необратимой.
        |Рекомендуется предварительно создать резервную копию базы данных.
        |Выполнить объединение карточек?'
        |;uk='Операція об''єднання карток з особистими даними є незворотною.
        |Рекомендується попередньо створити резервну копію бази даних.
        |Виконати об''єднання карток?'");
		
	Оповещение = Новый ОписаниеОповещения("ОбъединитьИОчиститьЗавершение", ЭтотОбъект);	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьИОчиститьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбъединитьИОчиститьНаКлиенте();
	УстановитьДоступностьКомандСравненияОбъединения(Элементы, НайденныеДубли.Количество() > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиЗадвоенныеДанные(Команда)
	
	Если НайденныеДубли.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='Список выбранных сотрудников будет очищен.
                            |Продолжить?'
                            |;uk='Список обраних співробітників буде очищений.
                            |Продовжити?'");
			
		Оповещение = Новый ОписаниеОповещения("НайтиЗадвоенныеДанныеЗавершение", ЭтотОбъект);	
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	Иначе 
		
		НайтиЗадвоенныеДанныеЗавершение(КодВозвратаДиалога.Да, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиЗадвоенныеДанныеЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеДубли.Очистить();
	
	ОткрытьФорму("Обработка.ОбъединениеКарточекСЛичнымиДанными.Форма.ФормаПоискаЗадублированныхФизическихЛиц", , Элементы.НайденныеДубли);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	
	Адрес = АдресДереваСравненияВХранилище();
	ПараметрыОткрытия.Вставить("ДеревоСравнения", Адрес);
	
	ОткрытьФорму("Обработка.ОбъединениеКарточекСЛичнымиДанными.Форма.ФормаПредварительногоПросмотра", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыОткрытия, Элементы.НайденныеДубли);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.НайденныеДубли.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НайденныеДублиПослеУдаленияНаСервере()
	
	СобратьИнформациюОбОсновныхДанных();
	
	УстановитьДоступностьКомандСравненияОбъединения(Элементы, НайденныеДубли.Количество() > 1);
	
КонецПроцедуры

&НаСервере
Процедура СобратьИнформациюОбОсновныхДанных()

	ДеревоСравнения.ПолучитьЭлементы().Очистить();
	Результат.ПолучитьЭлементы().Очистить();
	
	УстановитьДоступностьКомандСравненияОбъединения(Элементы, НайденныеДубли.Количество() > 1);
	
	Если НайденныеДубли.Количество() < 2 Тогда
		Возврат;
	КонецЕсли; 
	
	МассивФизлиц = НайденныеДубли.Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	// Подготовка реквизитов формы.
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ИзменитьРеквизитыФормы(ЭтаФорма, НайденныеДубли.Количество());
	
	// Строка ссылка
	СтрокаФизическогоЛица = НайтиПоле(ДеревоСравнения.ПолучитьЭлементы(), "Ссылка", НСтр("ru='Личные данные';uk='Особисті дані'"));
	Для Индекс = 0 По МассивФизлиц.Количество() - 1 Цикл
		СтрокаФизическогоЛица["Поле" + Индекс] = МассивФизлиц[Индекс];
	КонецЦикла;
	
	КлючевыеРеквизитыТабличныхЧастей = Новый Структура;
	КлючевыеРеквизитыТабличныхЧастей.Вставить("КонтактнаяИнформация", "Вид");
	КлючевыеРеквизитыТабличныхЧастей.Вставить("ДополнительныеРеквизиты", "Свойство");
	
	// Соберем информацию физического лица.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.ФИО,
	|	ФизическиеЛица.ДатаРождения,
	|	ФизическиеЛица.Пол,
	|	ФизическиеЛица.КодПоДРФО,
	|	ФизическиеЛица.МестоРождения,
	|	ФизическиеЛица.ДатаРегистрации,
	|	ФизическиеЛица.ИмеетНаучныеТруды,
	|	ФизическиеЛица.ИмеетИзобретения,
	|	ФизическиеЛица.ЛьготаПриНачисленииПособий,
	|	ФизическиеЛица.Ссылка,
	|	ФизическиеЛица.КонтактнаяИнформация.(
	|		Тип,
	|		Вид,
	|		Представление,
	|		ЗначенияПолей,
	|		Страна,
	|		Регион,
	|		Город,
	|		АдресЭП,
	|		ДоменноеИмяСервера,
	|		НомерТелефона,
	|		НомерТелефонаБезКодов
	|	),
	|	ФизическиеЛица.ДополнительныеРеквизиты.(
	|		Свойство,
	|		Значение,
	|		ТекстоваяСтрока
	|	)
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка В(&МассивФизическихЛиц)";
	
	Запрос.УстановитьПараметр("МассивФизическихЛиц", МассивФизлиц);
	
	ДеревоОсновныхДанных = Запрос.Выполнить().Выгрузить();
	
	ГруппаОсновныеДанные = СтрокаФизическогоЛица; 
	
	МДФизическогоЛица = Метаданные.Справочники.ФизическиеЛица;
	
	Для каждого СтрокаДеревоОсновныхДанных Из ДеревоОсновныхДанных Цикл
		
		ИндексФизическогоЛица = МассивФизлиц.Найти(СтрокаДеревоОсновныхДанных.Ссылка);
		Для каждого Колонка Из ДеревоОсновныхДанных.Колонки Цикл
			
			Если Колонка.Имя = "Ссылка" ИЛИ СтрНайти(ВРег(Колонка.Имя), "УДАЛИТЬ") = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(СтрокаДеревоОсновныхДанных[Колонка.Имя]) = Тип("ТаблицаЗначений") Тогда
				
				МДТабличнойЧасти = МДФизическогоЛица.ТабличныеЧасти.Найти(Колонка.Имя);
				ПолеДанных = НайтиПоле(ГруппаОсновныеДанные.ПолучитьЭлементы(), Колонка.Имя, МДТабличнойЧасти.Представление());
				
				ИмяКлючевогоРеквизита = Неопределено;
				КлючевыеРеквизитыТабличныхЧастей.Свойство(Колонка.Имя, ИмяКлючевогоРеквизита);
				
				ЗаполнитьПоТаблицеЗначений(ПолеДанных, СтрокаДеревоОсновныхДанных[Колонка.Имя], ИндексФизическогоЛица, МДТабличнойЧасти, ИмяКлючевогоРеквизита);
				
			Иначе
				
				МДКолонки = МДФизическогоЛица.Реквизиты.Найти(Колонка.Имя);
				Если МДКолонки = Неопределено Тогда
					Для каждого СтандартныйРеквизит Из МДФизическогоЛица.СтандартныеРеквизиты Цикл
						Если СтандартныйРеквизит.Имя = Колонка.Имя Тогда
							МДКолонки = СтандартныйРеквизит;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли; 
				
				ПолеДанных = НайтиПоле(ГруппаОсновныеДанные.ПолучитьЭлементы(), Колонка.Имя, МДКолонки.Представление());
				Если ЗначениеЗаполнено(СтрокаДеревоОсновныхДанных[Колонка.Имя]) Тогда
					ПолеДанных["Поле" + ИндексФизическогоЛица] = СтрокаДеревоОсновныхДанных[Колонка.Имя];
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Сбор данных по подчиненным справочникам.
	МассивОписаний = Обработки.ОбъединениеКарточекСЛичнымиДанными.ОписаниеСравниваемыхСправочников();
	Для каждого Описание Из МассивОписаний Цикл
		ЗаполнитьДанныеПодчиненногоСправочника(Описание, МассивФизлиц, ДеревоСравнения.ПолучитьЭлементы());
	КонецЦикла;
	
	// Сбор данных по регистрам сведений.
	МассивИменРегистровСведений = Обработки.ОбъединениеКарточекСЛичнымиДанными.ОписаниеСравниваемыхРегистровСведений();
	Для каждого ОписаниеРегистраСведений Из МассивИменРегистровСведений Цикл
		ЗаполнитьДанныеРегистра(ОписаниеРегистраСведений, МассивФизлиц, ДеревоСравнения.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НайтиПоле(Коллекция, Знач Поле, Представление = "", ДобавлятьЕслиНеНайдено = Истина)
	
	Поле = Строка(Поле);
	Для каждого ЭлементКоллекции Из Коллекция Цикл
		Если ЭлементКоллекции.Поле = Поле Тогда
			Возврат ЭлементКоллекции;
		КонецЕсли; 
	КонецЦикла;
	
	Если ДобавлятьЕслиНеНайдено Тогда
		ЭлементКоллекции = Коллекция.Добавить();
		ЭлементКоллекции.Поле = Поле;
		ЭлементКоллекции.Представление = Представление;
		Возврат ЭлементКоллекции;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоТаблицеЗначений(ПолеДанных, ТаблицаДанных, ИндексФизическогоЛица, МД, ИмяКлючевогоРеквизита)
	
	Если НЕ ПустаяСтрока(ИмяКлючевогоРеквизита)Тогда
		ИмяКолонки = ИмяКлючевогоРеквизита;
	ИначеЕсли ТаблицаДанных.Колонки.Найти("МесяцНалоговогоПериода") <> Неопределено Тогда
		ИмяКолонки = "МесяцНалоговогоПериода";
	ИначеЕсли ТаблицаДанных.Колонки.Найти("Период") <> Неопределено Тогда
		ИмяКолонки = "Период";
	ИначеЕсли ТаблицаДанных.Колонки.Найти("НомерПоПорядку") <> Неопределено Тогда
		ИмяКолонки = "НомерПоПорядку";
	Иначе
		ИмяКолонки = "НомерСтроки";
	КонецЕсли;
	
	СоответствиеПредставленийИмени = Новый Соответствие;
	Для каждого Реквизит Из МД.Реквизиты Цикл
		СоответствиеПредставленийИмени.Вставить(Реквизит.Имя, Реквизит.Представление());
	КонецЦикла;
	
	Если МД.Родитель() <> Метаданные.Справочники.ФизическиеЛица
		И МД <> Метаданные.Справочники.ОбразованиеФизическихЛиц
		И МД <> Метаданные.Справочники.РодственникиФизическихЛиц Тогда
		
		Для каждого Ресурс Из МД.СтандартныеРеквизиты Цикл
			СоответствиеПредставленийИмени.Вставить(Ресурс.Имя, Ресурс.Представление());
		КонецЦикла;
	
		Для каждого Измерение Из МД.Измерения Цикл
			СоответствиеПредставленийИмени.Вставить(Измерение.Имя, Измерение.Представление());
		КонецЦикла;
		
		Для каждого Ресурс Из МД.Ресурсы Цикл
			СоответствиеПредставленийИмени.Вставить(Ресурс.Имя, Ресурс.Представление());
		КонецЦикла;
	
	КонецЕсли; 
	
	Для каждого СтрокаТаблицаДанных Из ТаблицаДанных Цикл
		
		ПолеДанных1 = НайтиПоле(ПолеДанных.ПолучитьЭлементы(), СтрокаТаблицаДанных[ИмяКолонки], СтрокаТаблицаДанных[ИмяКолонки]);
		ПолеДанных1["Поле" + ИндексФизическогоЛица] = "";
		
		Для каждого Колонка Из ТаблицаДанных.Колонки Цикл
			
			Если Колонка.Имя = ИмяКолонки 
				И (ИмяКолонки = "НомерСтроки" ИЛИ ИмяКолонки = "НомерПоПорядку") Тогда
				Продолжить;
			КонецЕсли; 
			
			Если Колонка.Имя = "ФизическоеЛицо" Тогда
				Продолжить;
			КонецЕсли; 
			
			Если Колонка.Имя = "ФизЛицо" Тогда
				Продолжить;
			КонецЕсли; 
		
			Если СтрНайти(ВРег(Колонка.Имя), "УДАЛИТЬ") = 1 Тогда
				Продолжить;
			КонецЕсли; 
			
			Если СтрНайти(ВРег(СтрокаТаблицаДанных[Колонка.Имя]), "XML") = 0 Тогда
				
				ПолеДанных2 = НайтиПоле(ПолеДанных1.ПолучитьЭлементы(), Колонка.Имя, СоответствиеПредставленийИмени[Колонка.Имя]);
				Если ЗначениеЗаполнено(СтрокаТаблицаДанных[Колонка.Имя]) 
					ИЛИ ТипЗнч(СтрокаТаблицаДанных[Колонка.Имя]) = Тип("Булево") 
						И СтрокаТаблицаДанных[Колонка.Имя] = Ложь Тогда
						
					ПолеДанных2["Поле" + ИндексФизическогоЛица] = СтрокаТаблицаДанных[Колонка.Имя];
					
					Если НЕ ПустаяСтрока(СтрокаТаблицаДанных[Колонка.Имя]) Тогда
						
						ПолеДанных1["Поле" + ИндексФизическогоЛица] =
							?(НЕ ЗначениеЗаполнено(ПолеДанных1["Поле" + ИндексФизическогоЛица]), "", ПолеДанных1["Поле" + ИндексФизическогоЛица] + ", ")
								+ СтрокаТаблицаДанных[Колонка.Имя];
							
					КонецЕсли; 
					
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПодчиненногоСправочника(ОписаниеСправочника, МассивФизлиц, КоллекцияПолей)
	
	ИмяСправочника = ОписаниеСправочника.ИмяСправочника;
	МДСправочника = Метаданные.Справочники[ИмяСправочника];
	
	ОписаниеРеквизитов = "Т.Владелец";
	Если МДСправочника.ДлинаНаименования > 0 Тогда
		ОписаниеРеквизитов = ОписаниеРеквизитов + "," + Символы.ПС
			+ "	Т.Наименование";
	КонецЕсли; 
	
	Для каждого Реквизит Из МДСправочника.Реквизиты Цикл
		ОписаниеРеквизитов = ОписаниеРеквизитов + "," + Символы.ПС
			+ "	Т." + Реквизит.Имя;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Ссылка,
	|	" + ОписаниеРеквизитов + "
	|ПОМЕСТИТЬ ВТСсылки
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК Т
	|ГДЕ
	|	Т.Владелец В(&МассивФизлиц)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	" + ОписаниеРеквизитов + ",
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТМладшие.Ссылка) КАК НомерСтроки
	|ИЗ
	|	ВТСсылки КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСсылки КАК ТМладшие
	|		ПО Т.Ссылка > ТМладшие.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	" + ОписаниеРеквизитов + "
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	Запрос.УстановитьПараметр("МассивФизлиц", МассивФизлиц);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	ТаблицаСправочника = РезультатЗапроса.Выгрузить();
	ТаблицаСправочника.Колонки.Владелец.Имя = "ФизическоеЛицо";
	
	ПолеДанных1 = НайтиПоле(КоллекцияПолей, ИмяСправочника, МДСправочника.Представление());
	
	Для Индекс = 0 По МассивФизлиц.Количество() - 1 Цикл
		
		ЗаполнитьПоТаблицеЗначений(
			ПолеДанных1, ТаблицаСправочника.Скопировать(Новый Структура("ФизическоеЛицо", МассивФизлиц[Индекс])),
			Индекс, МДСправочника, );
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеРегистра(ОписаниеРегистраСведений, МассивФизлиц, КоллекцияПолей)
	
	ИмяРегистраСведений = ОписаниеРегистраСведений.ИмяРегистра;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РС.*
	|ИЗ
	|	РегистрСведений." + ИмяРегистраСведений + " КАК РС
	|ГДЕ
	|	РС.ФизическоеЛицо В(&МассивФизлиц)";
	
	Запрос.УстановитьПараметр("МассивФизлиц", МассивФизлиц);
	
	МДРегистраСведений = Метаданные.РегистрыСведений[ИмяРегистраСведений];
	
	ИспользуетсяРеквизитФизЛицо = МДРегистраСведений.Измерения.Найти("ФизическоеЛицо") = Неопределено;
	
	Если ИспользуетсяРеквизитФизЛицо Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ФизическоеЛицо", "ФизЛицо");
	КонецЕсли; 
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	ТаблицаРегистра = РезультатЗапроса.Выгрузить();
	
	Если ИспользуетсяРеквизитФизЛицо Тогда
		ТаблицаРегистра.Колонки.ФизЛицо.Имя = "ФизическоеЛицо";
	КонецЕсли;
	
	ПолеДанных1 = НайтиПоле(КоллекцияПолей, ИмяРегистраСведений, МДРегистраСведений.Представление());
	
	Для Индекс = 0 По МассивФизлиц.Количество() - 1 Цикл
		
		ЗаполнитьПоТаблицеЗначений(
			ПолеДанных1, ТаблицаРегистра.Скопировать(Новый Структура("ФизическоеЛицо", МассивФизлиц[Индекс])),
			Индекс, МДРегистраСведений,	ОписаниеРегистраСведений.ИмяКлючевогоРеквизита);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВладелецОставляемыхФИО()
	
	ВладелецФИО = Неопределено;
	
	СтрокаСсылка = НайтиПоле(ДеревоСравнения.ПолучитьЭлементы(), "Ссылка", , Ложь);
	Если СтрокаСсылка <> Неопределено Тогда
		СтрокаСФИО = НайтиПоле(СтрокаСсылка.ПолучитьЭлементы(), "ФИО", , Ложь);
		Если СтрокаСФИО <> Неопределено Тогда
			
			ИндексОтмеченного = Неопределено;
			Для ИндексФизическогоЛица = 0 По НайденныеДубли.Количество() - 1 Цикл
				
				Если СтрокаСФИО["ПолеПометка" + ИндексФизическогоЛица] Тогда
					ИндексОтмеченного = ИндексФизическогоЛица;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если ИндексОтмеченного <> Неопределено Тогда
				ВладелецФИО = НайденныеДубли.Получить(ИндексОтмеченного).ФизическоеЛицо;
			КонецЕсли;
			
		КонецЕсли; 
	КонецЕсли;
	
	Возврат ВладелецФИО;
	
КонецФункции

&НаСервере
Функция ОбъединитьИОчиститьНаСервере()
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьРезультат(ДеревоСравнения, Результат, НайденныеДубли);
	
	РезультатОбъединения = Новый ДеревоЗначений;
	РезультатОбъединения.Колонки.Добавить("Поле");
	РезультатОбъединения.Колонки.Добавить("Значение");
	
	ДобавитьСтрокиВРезультатОбъединения(РезультатОбъединения, Результат.ПолучитьЭлементы());
		
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("РезультатОбъединения", РезультатОбъединения);
	ПараметрыВыполнения.Вставить("МассивФизическихЛиц" , НайденныеДубли.Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо"));
	ПараметрыВыполнения.Вставить("ВладелецОставляемыхФИО", ВладелецОставляемыхФИО());
	
	РезультатРаботыЗадания = Новый Структура("ЗаданиеВыполнено", Истина);
	
	РезультатРаботыЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ОбъединениеКарточекСЛичнымиДанными.ОбъединитьИОчиститьЗадвоенныеДанныеФизическихЛиц",
		ПараметрыВыполнения,
		НСтр("ru='Производится объединение задвоенных данных физических лиц';uk='Проводиться об''єднання задвоенных даних фізичних осіб'"));
	
	АдресХранилища = РезультатРаботыЗадания.АдресХранилища;
		
	Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		ОчиститьДанныеОбработки();
	КонецЕсли;
	
	Возврат РезультатРаботыЗадания;
	
КонецФункции
	
&НаСервере
Процедура ДобавитьСтрокиВРезультатОбъединения(Родитель, КоллекцияСтрокРезультата)
	
	Для каждого СтрокаРезультата Из КоллекцияСтрокРезультата Цикл
		
		НоваяСтрока = Родитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		
		ДобавитьСтрокиВРезультатОбъединения(НоваяСтрока, СтрокаРезультата.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеОбработки()
	
	ДеревоСравнения.ПолучитьЭлементы().Очистить();
	НайденныеДубли.Очистить();
	Результат.ПолучитьЭлементы().Очистить();
	
КонецПроцедуры

#Область ПроцедурыИФункцииМеханизмаВыполненияДлительныхОпераций

&НаКлиенте
Процедура ОбъединитьИОчиститьНаКлиенте()
	
	РезультатРаботыЗадания = ОбъединитьИОчиститьНаСервере();
	
	Если Не РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	Иначе
		
		Если РезультатРаботыЗадания.Свойство("РезультатОбъединения") Тогда
			УведомитьОРезультатахРаботы(РезультатРаботыЗадания.РезультатОбъединения);
		Иначе
			УведомитьОРезультатахРаботы(ПолучитьИзВременногоХранилища(АдресХранилища));
		КонецЕсли; 
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				Состояние(НСтр("ru='Процесс формирования кадровых приказов завершен';uk='Процес формування кадрових наказів завершено'"));
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
				УведомитьОРезультатахРаботы(ПолучитьИзВременногоХранилища(АдресХранилища));
					
				ВывестиСообщенияФоновогоЗадания();
				
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
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщенияФоновогоЗадания()
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		МассивСообщений = ФоновоеЗадание.ПолучитьСообщенияПользователю(Истина);
		Если МассивСообщений <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из МассивСообщений Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
			
КонецПроцедуры

&НаКлиенте
Процедура УведомитьОРезультатахРаботы(ОбъединениеВыполнено)
	
	Если ОбъединениеВыполнено = Истина Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='Объединение данных выполнено.
            |Для окончательного удаления задвоенных данных выполните удаление помеченных объектов.'
            |;uk='Об''єднання даних виконано.
            |Для остаточного вилучення задвоенных даних виконайте вилучення відмічених об''єктів.'"));
					
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru='Во время выполнения объединения задвоенных данных возникли ошибки.
            |Необходимо устранить ошибки и повторить операцию объединения.'
            |;uk='Під час виконання об''єднання подвоєних даних виникли помилки.
            |Необхідно усунути помилки і повторити операцію об''єднання.'"));
					
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция АдресДереваСравненияВХранилище()
	
	Возврат Обработки.ОбъединениеКарточекСЛичнымиДанными.АдресКоллекцииВХранилище(ЭтаФорма, "ДеревоСравнения");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоСравненияНаСервере(АдресДереваСравненияВХранилище)
	
	КоллекцияДеревоСравнения = ПолучитьИзВременногоХранилища(АдресДереваСравненияВХранилище);
	
	ДеревоСравнения.ПолучитьЭлементы().Очистить();
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ИзменитьРеквизитыФормы(ЭтаФорма, НайденныеДубли.Количество());
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьКоллекцию(ДеревоСравнения.ПолучитьЭлементы(), КоллекцияДеревоСравнения);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВыбранныеФизическиеЛица(ВыбранныеЗначения)
	
	МассивДобавляемых = Новый Массив;
	
	Для каждого ВыбранноеЗначение Из ВыбранныеЗначения Цикл
		
		СтруктураПоиска = Новый Структура("ФизическоеЛицо", ВыбранноеЗначение);
		
		Если НайденныеДубли.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			МассивДобавляемых.Добавить(ВыбранноеЗначение);
		КонецЕсли; 
		
	КонецЦикла;
	
	Если МассивДобавляемых.Количество() > 0 Тогда
		
		ДанныеСотрудников = ПодробныеДанныеСотрудников(МассивДобавляемых);
		
		Для каждого ДобавляемыеДанные Из ДанныеСотрудников Цикл
			
			НоваяСтрокаНайденныеДубли = НайденныеДубли.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНайденныеДубли, ДобавляемыеДанные);
			
		КонецЦикла;
		
		СобратьИнформациюОбОсновныхДанных();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПодробныеДанныеСотрудников(МассивСотрудников)
		
	Возврат КадровыйУчет.КадровыеДанныеФизическихЛиц(
		Ложь, МассивСотрудников, "КодПоДРФО,ДокументВид,ДокументСерия,ДокументНомер,ДокументПредставление");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандСравненияОбъединения(Элементы, Значение)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПредварительныйПросмотр",
		"Доступность",
		Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОбъединитьИОчистить",
		"Доступность",
		Значение);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
