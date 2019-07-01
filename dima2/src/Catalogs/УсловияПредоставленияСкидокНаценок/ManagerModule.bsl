#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("УсловиеПредоставления");
	Результат.Добавить("ВариантОпределенияПериодаНакопительнойСкидки");
	
	Результат.Добавить("ВариантНакопления");
	Результат.Добавить("КритерийОграниченияПримененияЗаОбъемПродаж");
	Результат.Добавить("ВалютаОграничения");
	Результат.Добавить("ГрафикОплаты");
	Результат.Добавить("ФормаОплаты");
	Результат.Добавить("ЗначениеУсловияОграничения");
	Результат.Добавить("СегментНоменклатурыОграничения");
	Результат.Добавить("ПериодНакопления");
	Результат.Добавить("ТипСравнения");
	Результат.Добавить("ГруппаПользователей");
	Результат.Добавить("ВремяДействия");
	Результат.Добавить("ВидКартыЛояльности");
	Результат.Добавить("КоличествоПериодовНакопления");
	Результат.Добавить("СегментПартнеров");
	Результат.Добавить("ВариантОтбораНоменклатуры");
	Результат.Добавить("ВключатьТекущуюПродажуВНакопленныйОбъемПродаж");
	Результат.Добавить("КоличествоДнейПослеДняРождения");
	Результат.Добавить("КоличествоДнейДоДняРождения");

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления BAS УТ 3.2.2
// Преобразовывает условия предоставления скидок (наценок) по строке в отбор номенклатуры скидки (наценки)
Процедура ПреобразоватьУсловияПоСтрокеВОтборыНоменклатурыСкидокНаценок() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УсловияПредоставленияСкидокНаценок.Ссылка
	|ПОМЕСТИТЬ УсловияПоСтроке
	|ИЗ
	|	Справочник.УсловияПредоставленияСкидокНаценок КАК УсловияПредоставленияСкидокНаценок
	|ГДЕ
	|	УсловияПредоставленияСкидокНаценок.УдалитьОбластьОграничения = &ОбластьОграничения
	|	И УсловияПредоставленияСкидокНаценок.УсловиеПредоставления = &ЗаРазовыйОбъемПродаж
	|
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ТабличнаяЧасть.Ссылка.Родитель.ВариантСовместногоПрименения КАК ВариантСовместногоПрименения,
	|	ТабличнаяЧасть.УсловиеПредоставления КАК УсловиеПредоставления,
	|	ТабличнаяЧасть.УсловиеПредоставления.ЗначениеУсловияОграничения КАК ЗначениеУсловияОграничения,
	|	ТабличнаяЧасть.УсловиеПредоставления.ТипСравнения КАК ТипСравнения,
	|	ТабличнаяЧасть.УсловиеПредоставления.КритерийОграниченияПримененияЗаОбъемПродаж КАК КритерийОграниченияПримененияЗаОбъемПродаж,
	|	ТабличнаяЧасть.УсловиеПредоставления.СегментНоменклатурыОграничения КАК СегментНоменклатурыОграничения
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК ТабличнаяЧасть
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ УсловияПоСтроке
	|		ПО УсловияПоСтроке.Ссылка = ТабличнаяЧасть.УсловиеПредоставления
	|ИТОГИ ПО
	|	ТабличнаяЧасть.Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	Условия.Ссылка КАК Ссылка
	|ИЗ
	|	УсловияПоСтроке КАК Условия
	|ГДЕ
	|	Условия.Ссылка Не В (ВЫБРАТЬ Т.Ссылка Из Справочник.СкидкиНаценки.УсловияПредоставления КАК Т)
	|";
	
	Запрос.УстановитьПараметр("ОбластьОграничения", Перечисления.ВариантыОбластейОграниченияСкидокНаценок.ВСтроке);
	Запрос.УстановитьПараметр("ЗаРазовыйОбъемПродаж", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж);
	
	ОтборСтрокНоменклатура = Справочники.СкидкиНаценки.ПолучитьМакет("ОтборСтрокНоменклатура");
	ОтборСтрокДополнительныеУсловия = Справочники.СкидкиНаценки.ПолучитьМакет("ОтборСтрокДополнительныеУсловия");
	
	КУдалению = Новый Массив;
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаСкидкиНаценки = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСкидкиНаценки.Следующий() Цикл
		
		СкидкаНаценкаОбъект = ВыборкаСкидкиНаценки.Ссылка.ПолучитьОбъект();
		
		Настройки = СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных.Получить();
		
		Если Настройки = Неопределено Тогда
		
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(ОтборСтрокНоменклатура.НастройкиПоУмолчанию);
			
			КомпоновщикНастроекДополнительныеУсловия = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекДополнительныеУсловия.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокДополнительныеУсловия));
			КомпоновщикНастроекДополнительныеУсловия.ЗагрузитьНастройки(ОтборСтрокДополнительныеУсловия.НастройкиПоУмолчанию);
			
		Иначе
			
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(Настройки.ОтборПоНоменклатуре);
			
			КомпоновщикНастроекДополнительныеУсловия = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекДополнительныеУсловия.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокДополнительныеУсловия));
			КомпоновщикНастроекДополнительныеУсловия.ЗагрузитьНастройки(Настройки.ДополнительныеУсловия);
			
		КонецЕсли;
		
		ВыборкаУсловияПрименения = ВыборкаСкидкиНаценки.Выбрать();
		Пока ВыборкаУсловияПрименения.Следующий() Цикл
			
			Если ЗначениеЗаполнено(ВыборкаУсловияПрименения.СегментНоменклатурыОграничения) Тогда
				
				Если Не ЗначениеЗаполнено(СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры)
					ИЛИ СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.БезОграничений Тогда
					
					СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры;
					СкидкаНаценкаОбъект.СегментНоменклатурыОграничения = ВыборкаУсловияПрименения.СегментНоменклатурыОграничения;
					
				ИначеЕсли СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры
					И СкидкаНаценкаОбъект.СегментНоменклатурыОграничения = ВыборкаУсловияПрименения.СегментНоменклатурыОграничения Тогда
					
					// Ничего не нужно менять
					
				ИначеЕсли СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры
					И СкидкаНаценкаОбъект.СегментНоменклатурыОграничения <> ВыборкаУсловияПрименения.СегментНоменклатурыОграничения Тогда
					
					ЭлементОтбора = КомпоновщикНастроекОтборПоНоменклатуре.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СегментНоменклатуры");
					ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
					ЭлементОтбора.ПравоеЗначение = СкидкаНаценкаОбъект.СегментНоменклатурыОграничения;
					ЭлементОтбора.Использование = Истина;
					
					ЭлементОтбора = КомпоновщикНастроекОтборПоНоменклатуре.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СегментНоменклатуры");
					ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
					ЭлементОтбора.ПравоеЗначение = ВыборкаУсловияПрименения.СегментНоменклатурыОграничения;
					ЭлементОтбора.Использование = Истина;
					
					СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.ОтборКомпоновкиДанных;
					СкидкаНаценкаОбъект.СегментНоменклатурыОграничения = Неопределено;
					
				ИначеЕсли СкидкаНаценкаОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.ОтборКомпоновкиДанных Тогда
					
					ЭлементОтбора = КомпоновщикНастроекОтборПоНоменклатуре.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СегментНоменклатуры");
					ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
					ЭлементОтбора.ПравоеЗначение = ВыборкаУсловияПрименения.СегментНоменклатурыОграничения;
					ЭлементОтбора.Использование = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ЭлементОтбора = КомпоновщикНастроекДополнительныеУсловия.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Если Перечисления.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество = ВыборкаУсловияПрименения.КритерийОграниченияПримененияЗаОбъемПродаж Тогда
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Количество");
			Иначе
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сумма");
			КонецЕсли;
			Если Перечисления.ТипыСравненияЗначенийСкидокНаценок.НеБолее = ВыборкаУсловияПрименения.ТипСравнения Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ВыборкаУсловияПрименения.ЗначениеУсловияОграничения;
			ЭлементОтбора.Использование = Истина;
			
			Индекс = СкидкаНаценкаОбъект.УсловияПредоставления.Найти(ВыборкаУсловияПрименения.УсловиеПредоставления, "УсловиеПредоставления");
			СкидкаНаценкаОбъект.УсловияПредоставления.Удалить(Индекс);
			КУдалению.Добавить(ВыборкаУсловияПрименения.УсловиеПредоставления);
			
		КонецЦикла;
		
		НастройкиКомпоновкиДанных = Новый Структура;
		НастройкиКомпоновкиДанных.Вставить("ОтборПоНоменклатуре", КомпоновщикНастроекОтборПоНоменклатуре.ПолучитьНастройки());
		НастройкиКомпоновкиДанных.Вставить("ДополнительныеУсловия", КомпоновщикНастроекДополнительныеУсловия.ПолучитьНастройки());
		
		// Поместить настройки без кэшированного запроса.
		// Функция ДанныеФильтраПоНоменклатуре считывает настройки из объекта для подготовки кэшированного запроса
		СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		СкидкиНаценкиСервер.ВставитьКэшированныйЗапрос(НастройкиКомпоновкиДанных, СкидкаНаценкаОбъект);
		
		Если ВыборкаСкидкиНаценки.ВариантСовместногоПрименения = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Умножение Тогда
			СкидкаНаценкаОбъект.ПрименятьУмножениеВРамкахВышестоящейГруппы = Истина;
		КонецЕсли;
		СкидкаНаценкаОбъект.УчитыватьХарактеристики = Истина;
		
		СкидкаНаценкаОбъект.УстановленДополнительныйОтбор = ЗначениеЗаполнено(Строка(КомпоновщикНастроекДополнительныеУсловия.Настройки.Отбор));
		СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СкидкаНаценкаОбъект);
	
	КонецЦикла;
	
	ВыборкаУсловия = Результат[2].Выбрать();
	Пока ВыборкаУсловия.Следующий() Цикл
		КУдалению.Добавить(ВыборкаУсловия.Ссылка);
	КонецЦикла;
	
	Для Каждого Ссылка ИЗ КУдалению Цикл
		Объект = Ссылка.ПолучитьОбъект();
		Объект.УдалитьОбластьОграничения = Перечисления.ВариантыОбластейОграниченияСкидокНаценок.ВДокументе;
		Объект.ПометкаУдаления = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Преобразовывает условие предоставления "За пробную продажу" в отбор номенклатуры скидки (наценки).
Процедура ПреобразоватьУсловиеПробнаяПродажаВОтборыНоменклатурыСкидокНаценок() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УсловияПредоставленияСкидокНаценок.Ссылка
	|ПОМЕСТИТЬ УсловияПоСтроке
	|ИЗ
	|	Справочник.УсловияПредоставленияСкидокНаценок КАК УсловияПредоставленияСкидокНаценок
	|ГДЕ
	|	УсловияПредоставленияСкидокНаценок.УсловиеПредоставления = &ЗаПробнуюПродажу
	|
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ТабличнаяЧасть.Ссылка.Родитель.ВариантСовместногоПрименения КАК ВариантСовместногоПрименения,
	|	ТабличнаяЧасть.УсловиеПредоставления КАК УсловиеПредоставления
	|ИЗ
	|	Справочник.СкидкиНаценки.УсловияПредоставления КАК ТабличнаяЧасть
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ УсловияПоСтроке
	|		ПО УсловияПоСтроке.Ссылка = ТабличнаяЧасть.УсловиеПредоставления
	|ИТОГИ ПО
	|	ТабличнаяЧасть.Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	Условия.Ссылка КАК Ссылка
	|ИЗ
	|	УсловияПоСтроке КАК Условия
	|ГДЕ
	|	Условия.Ссылка Не В (ВЫБРАТЬ Т.Ссылка Из Справочник.СкидкиНаценки.УсловияПредоставления КАК Т)
	|";
	
	Запрос.УстановитьПараметр("ЗаПробнуюПродажу", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаПробнуюПродажу);
	
	ОтборСтрокНоменклатура = Справочники.СкидкиНаценки.ПолучитьМакет("ОтборСтрокНоменклатура");
	ОтборСтрокДополнительныеУсловия = Справочники.СкидкиНаценки.ПолучитьМакет("ОтборСтрокДополнительныеУсловия");
	
	КУдалению = Новый Массив;
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаСкидкиНаценки = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСкидкиНаценки.Следующий() Цикл
		
		СкидкаНаценкаОбъект = ВыборкаСкидкиНаценки.Ссылка.ПолучитьОбъект();
		
		Настройки = СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных.Получить();
		
		Если Настройки = Неопределено Тогда
		
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(ОтборСтрокНоменклатура.НастройкиПоУмолчанию);
			
			КомпоновщикНастроекДополнительныеУсловия = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекДополнительныеУсловия.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокДополнительныеУсловия));
			КомпоновщикНастроекДополнительныеУсловия.ЗагрузитьНастройки(ОтборСтрокДополнительныеУсловия.НастройкиПоУмолчанию);
			
		Иначе
			
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(Настройки.ОтборПоНоменклатуре);
			
			КомпоновщикНастроекДополнительныеУсловия = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекДополнительныеУсловия.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокДополнительныеУсловия));
			КомпоновщикНастроекДополнительныеУсловия.ЗагрузитьНастройки(Настройки.ДополнительныеУсловия);
			
		КонецЕсли;
		
		ВыборкаУсловияПрименения = ВыборкаСкидкиНаценки.Выбрать();
		Пока ВыборкаУсловияПрименения.Следующий() Цикл
			
			ЭлементОтбора = КомпоновщикНастроекДополнительныеУсловия.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КлиентПокупаетТоварВПервыйРаз");
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.ПравоеЗначение = Истина;
			ЭлементОтбора.Использование = Истина;
			
			Индекс = СкидкаНаценкаОбъект.УсловияПредоставления.Найти(ВыборкаУсловияПрименения.УсловиеПредоставления, "УсловиеПредоставления");
			СкидкаНаценкаОбъект.УсловияПредоставления.Удалить(Индекс);
			КУдалению.Добавить(ВыборкаУсловияПрименения.УсловиеПредоставления);
			
		КонецЦикла;
		
		НастройкиКомпоновкиДанных = Новый Структура;
		НастройкиКомпоновкиДанных.Вставить("ОтборПоНоменклатуре", КомпоновщикНастроекОтборПоНоменклатуре.ПолучитьНастройки());
		НастройкиКомпоновкиДанных.Вставить("ДополнительныеУсловия", КомпоновщикНастроекДополнительныеУсловия.ПолучитьНастройки());
		
		// Поместить настройки без кэшированного запроса.
		// Функция ДанныеФильтраПоНоменклатуре считывает настройки из объекта для подготовки кэшированного запроса
		СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		СкидкиНаценкиСервер.ВставитьКэшированныйЗапрос(НастройкиКомпоновкиДанных, СкидкаНаценкаОбъект);
		
		Если ВыборкаСкидкиНаценки.ВариантСовместногоПрименения = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Умножение Тогда
			СкидкаНаценкаОбъект.ПрименятьУмножениеВРамкахВышестоящейГруппы = Истина;
		КонецЕсли;
		СкидкаНаценкаОбъект.УчитыватьХарактеристики = Истина;
		
		СкидкаНаценкаОбъект.УстановленДополнительныйОтбор = ЗначениеЗаполнено(Строка(КомпоновщикНастроекДополнительныеУсловия.Настройки.Отбор));
		СкидкаНаценкаОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СкидкаНаценкаОбъект);
		
	КонецЦикла;
	
	ВыборкаУсловия = Результат[2].Выбрать();
	Пока ВыборкаУсловия.Следующий() Цикл
		КУдалению.Добавить(ВыборкаУсловия.Ссылка);
	КонецЦикла;
	
	Для Каждого Ссылка ИЗ КУдалению Цикл
		Объект = Ссылка.ПолучитьОбъект();
		Объект.ПометкаУдаления = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
Процедура ПреобразоватьУсловиеПерваяПродажаПартнеруВУсловиеЗаНакопленныйОбъемПродаж() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УсловияПредоставленияСкидокНаценок.Ссылка
	|ИЗ
	|	Справочник.УсловияПредоставленияСкидокНаценок КАК УсловияПредоставленияСкидокНаценок
	|ГДЕ
	|	УсловияПредоставленияСкидокНаценок.УсловиеПредоставления = &ЗаПервуюПродажуПартнеру
	|";
	
	Запрос.УстановитьПараметр("ЗаПервуюПродажуПартнеру", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаПервуюПродажуПартнеру);
	
	Результат = Запрос.Выполнить();
	ВыборкаУсловия = Результат.Выбрать();
	Пока ВыборкаУсловия.Следующий() Цикл
		
		Объект = ВыборкаУсловия.Ссылка.ПолучитьОбъект();
		Объект.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж;
		Объект.КритерийОграниченияПримененияЗаОбъемПродаж = Перечисления.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество;
		Объект.ВариантОпределенияПериодаНакопительнойСкидки = Перечисления.ВариантыОпределенияПериодаНакопительнойСкидки.ВесьПериод;
		Объект.ВариантНакопления = Перечисления.ВариантыНакопленияКумулятивнойСкидкиНаценки.ПоПартнеру;
		Объект.ТипСравнения = Перечисления.ТипыСравненияЗначенийСкидокНаценок.НеБолее;
		Объект.ЗначениеУсловияОграничения = 0;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Заполняет поле "Вариант отбора номенклатуры" в справочнике "Условия предоставления скидок (наценок)"
Процедура ЗаполнитьВариантОтбораНоменклатуры() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УсловияПредоставленияСкидокНаценок.Ссылка,
	|	УсловияПредоставленияСкидокНаценок.ВариантОтбораНоменклатуры,
	|	УсловияПредоставленияСкидокНаценок.СегментНоменклатурыОграничения,
	|	УсловияПредоставленияСкидокНаценок.ФормаОплаты
	|ИЗ
	|	Справочник.УсловияПредоставленияСкидокНаценок КАК УсловияПредоставленияСкидокНаценок
	|ГДЕ
	|	УсловияПредоставленияСкидокНаценок.ВариантОтбораНоменклатуры = &ВариантОтбораНоменклатуры
	|";
	
	Запрос.УстановитьПараметр("ВариантОтбораНоменклатуры", Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.ПустаяСсылка());
	
	ОтборСтрокНоменклатура = Справочники.СкидкиНаценки.ПолучитьМакет("ОтборУсловияПредоставленияСуммаКоличество");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Неопределено;
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(Объект.СегментНоменклатурыОграничения) Тогда
			Объект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры;
		Иначе
			Объект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.БезОграничений;
		КонецЕсли;
		
		Настройки = Объект.ХранилищеНастроекКомпоновкиДанных.Получить();
		
		Если Настройки = Неопределено Тогда
		
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(ОтборСтрокНоменклатура.НастройкиПоУмолчанию);
			
		Иначе
			
			КомпоновщикНастроекОтборПоНоменклатуре = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроекОтборПоНоменклатуре.Инициализировать(
				Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтборСтрокНоменклатура));
			КомпоновщикНастроекОтборПоНоменклатуре.ЗагрузитьНастройки(Настройки.ОтборПоНоменклатуре);
			
		КонецЕсли;
		
		НастройкиКомпоновкиДанных = Новый Структура;
		НастройкиКомпоновкиДанных.Вставить("ОтборПоНоменклатуре", КомпоновщикНастроекОтборПоНоменклатуре.ПолучитьНастройки());
		
		// Поместить настройки без кэшированного запроса.
		// Функция ДанныеФильтраПоНоменклатуре считывает настройки из объекта для подготовки кэшированного запроса
		Объект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		СкидкиНаценкиСервер.ВставитьКэшированныйЗапрос(НастройкиКомпоновкиДанных, Объект);
		
		Если Объект.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж
			ИЛИ Объект.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж Тогда
			Объект.УчитыватьХарактеристики = Истина;
		КонецЕсли;
		
		Объект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти

#КонецЕсли