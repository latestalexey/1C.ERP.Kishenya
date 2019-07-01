#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Параметры планирования работы рабочих центров вида РЦ ""%1""';uk='Параметри планування роботи робочих центрів виду РЦ ""%1""'"),
						Параметры.ДанныеОбъекта.НаименованиеВидаРЦ);
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.ДанныеОбъекта);
	
	ВремяПереналадки = Параметры.ДанныеОбъекта.ВремяПереналадки;
	ПараллельнаяЗагрузка = Число(Параметры.ДанныеОбъекта.ПараллельнаяЗагрузка);
	
	ЗаполнитьВыборЕдиницыИзмеренияЗагрузки();
	
	УправлениеВводомВремениРаботы(ЭтаФорма);
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПараллельнаяЗагрузка = 1 Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмеренияЗагрузки) Тогда
			ТекстСообщения = НСтр("ru='Поле ""Единица измерения загрузки"" не заполнено.';uk='Поле ""Одиниця вимірювання завантаження"" не заповнено.'");
   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ЕдиницаИзмеренияЗагрузки", "Объект", Отказ);
		КонецЕсли; 
		
		Если Объект.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный 
			И НЕ Объект.ИспользуютсяВариантыНаладки Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.ВремяРаботы) Тогда
				ТекстСообщения = НСтр("ru='Поле ""Время работы"" не заполнено.';uk='Поле ""Час роботи"" не заповнено.'");
	   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ВремяРаботы", "Объект", Отказ);
			КонецЕсли; 
			Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
				ТекстСообщения = НСтр("ru='Поле ""Единица измерения времени"" не заполнено.';uk='Поле ""Одиниця вимірювання часу"" не заповнено.'");
	   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ЕдиницаИзмерения", "Объект", Отказ);
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если Объект.ИспользуютсяВариантыНаладки Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаВремениПереналадки) Тогда
			ТекстСообщения = НСтр("ru='Поле ""Единица времени переналадки"" не заполнено.';uk='Поле ""Одиниця часу переналадки"" не заповнено.'");
   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ЕдиницаИзмеренияЗагрузки", "Объект", Отказ);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользуютсяВариантыНаладкиПриИзменении(Элемент)
	
	ИспользуютсяВариантыНаладкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараллельнаяЗагрузкаПриИзменении(Элемент)
	
	Если ПараллельнаяЗагрузка = 1
		И Объект.ВариантЗагрузки = ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиРабочихЦентров.ПустаяСсылка") Тогда
		Объект.ВариантЗагрузки = ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиРабочихЦентров.Асинхронный");
	ИначеЕсли ПараллельнаяЗагрузка = 0
		И Объект.ВариантЗагрузки <> ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиРабочихЦентров.ПустаяСсылка") Тогда
		Объект.ВариантЗагрузки = ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиРабочихЦентров.ПустаяСсылка");
	КонецЕсли;
	
	УправлениеВводомВремениРаботы(ЭтаФорма);
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗагрузкиАсинхронныйПриИзменении(Элемент)
	
	УправлениеВводомВремениРаботы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗагрузкиСинхронный2ПриИзменении(Элемент)
	
	УправлениеВводомВремениРаботы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Переналадка

&НаСервере
Процедура ИспользуютсяВариантыНаладкиПриИзмененииНаСервере()

	Если Объект.ИспользуютсяВариантыНаладки И Объект.ЕдиницаВремениПереналадки.Пустая() Тогда
		Объект.ЕдиницаВремениПереналадки = Перечисления.ЕдиницыИзмеренияВремени.Минута;
	ИначеЕсли НЕ Объект.ИспользуютсяВариантыНаладки И НЕ Объект.ЕдиницаВремениПереналадки.Пустая() Тогда
		Объект.ЕдиницаВремениПереналадки = Перечисления.ЕдиницыИзмеренияВремени.ПустаяСсылка();
	КонецЕсли; 
	
	УправлениеВводомВремениРаботы(ЭтаФорма);
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ПараллельнаяЗагрузка

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВводомВремениРаботы(Форма)
	
	Если Форма.ПараллельнаяЗагрузка = 1
		И Форма.Объект.ИспользуютсяВариантыНаладки Тогда
		ТекущаяСтраница = Форма.Элементы.СтраницаСинхроннаяЗагрузкаБезВремениРаботы;
	Иначе
		ТекущаяСтраница = Форма.Элементы.СтраницаСинхроннаяЗагрузкаСВременемРаботы;
	КонецЕсли; 

	Форма.Элементы.СтраницыСинхроннаяЗагрузка.ТекущаяСтраница = ТекущаяСтраница;
	
	СинхроннаяЗагрузка = (Форма.Объект.ВариантЗагрузки = ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиРабочихЦентров.Синхронный"));
	Форма.Элементы.ВремяРаботы.Доступность = СинхроннаяЗагрузка;
	Форма.Элементы.ЕдиницаИзмерения.Доступность = СинхроннаяЗагрузка;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// ОтметкаНезаполненного для переналадки
	#Область ПереналадкаОтметка
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЕдиницаВремениПереналадки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользуютсяВариантыНаладки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти

	// ОтметкаНезаполненного для ед. изм. загрузки
	#Область ЕдИзмЗагрузкиОтметка
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЕдиницаИзмеренияЗагрузки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараллельнаяЗагрузка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти
	
	// ОтметкаНезаполненного для времени работы
	#Область ВремяРаботыОтметка
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВремяРаботы.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЕдиницаИзмерения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВариантЗагрузки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыборЕдиницыИзмеренияЗагрузки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕдиницыИзмерения.Наименование КАК Наименование
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	НЕ ЕдиницыИзмерения.ПометкаУдаления
	|	И ЕдиницыИзмерения.Владелец = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.БазовыеЕдиницыИзмерения)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Наименование");
	Элементы.ЕдиницаИзмеренияЗагрузки.СписокВыбора.ЗагрузитьЗначения(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()

	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	РезультатНастройки = Новый Структура("ЕдиницаИзмеренияЗагрузки,ВариантЗагрузки,
										|ВремяРаботы,ЕдиницаИзмерения,ЕдиницаВремениПереналадки,
										|ИспользуютсяВариантыНаладки");
	
	ЗаполнитьЗначенияСвойств(РезультатНастройки, Объект);
	
	РезультатНастройки.Вставить("ПараллельнаяЗагрузка", Булево(ПараллельнаяЗагрузка));
	РезультатНастройки.Вставить("ВремяПереналадки", ВремяПереналадки);
	
	Модифицированность = Ложь;
	
	Закрыть(РезультатНастройки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	ДоступнаПараллельнаяЗагрузка = (Форма.ПараллельнаяЗагрузка = 1);
	
	Форма.Элементы.ВремяПереналадки.Доступность = Форма.Объект.ИспользуютсяВариантыНаладки;
	Форма.Элементы.ЕдиницаВремениПереналадки.Доступность  = Форма.Объект.ИспользуютсяВариантыНаладки;;
	Форма.Элементы.ЕдиницаИзмеренияЗагрузки.Доступность = ДоступнаПараллельнаяЗагрузка; 
	Форма.Элементы.ВариантЗагрузкиАсинхронный.Доступность = ДоступнаПараллельнаяЗагрузка;
	Форма.Элементы.ВариантЗагрузкиСинхронный1.Доступность = ДоступнаПараллельнаяЗагрузка; 
	Форма.Элементы.ВариантЗагрузкиСинхронный2.Доступность = ДоступнаПараллельнаяЗагрузка;
														
КонецПроцедуры

#КонецОбласти

#КонецОбласти
