#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПрочитатьЗначенияПараметров();
	
	БылиНажатыКнопкиЗакрытия = Ложь;
	
	Если НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ПравоНаДобавлениеНоменклатурыГТД = ПравоДоступа("Добавление", Метаданные.Справочники.НоменклатураГТД);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ПравоНаДобавлениеНоменклатурыГТД Тогда
		Настройки["СоздаватьНоменклатуруГТД"] = Неопределено;
		СоздаватьНоменклатуруГТД = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// В зависимости от считанных настроек
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если БылиНажатыКнопкиЗакрытия = Истина Или Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = "";
	
	ТекстВопроса = ?(ПустаяСтрока(ТекстПредупреждения), 
		НСтр("ru='Данные были изменены, внесенные изменения будут отменены.
                   |Отменить и закрыть?'
                   |;uk='Дані були змінені, внесені зміни будуть скасовані.
                   |Скасувати й закрити?'"),
		ТекстПредупреждения);
		
	Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, 
		НСтр("ru='Отмена изменений';uk='Скасування змін'"));
		
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура СоздаватьНоменклатуруГТДПриИзменении(Элемент)
	УстановитьДоступность(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОКВыполнить()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть(ПолучитьЗначенияПараметров());
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменаВыполнить()
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьЗначенияПараметров()
	
	Для Каждого ЭлементТелефона Из Параметры.ЗначенияПолей Цикл
		ЭтаФорма[ЭлементТелефона.Представление] = ЭлементТелефона.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ЗначенияПолей",    
		Новый Структура("КодУКТВЭД, НомерГТД", КодУКТВЭД, НомерГТД));
		
	Результат.Вставить("НастрокиСоздания", 
		Новый Структура("СоздаватьНоменклатуруГТД, Комментарий", СоздаватьНоменклатуруГТД, Комментарий));
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)
	
	Форма.Элементы.Комментарий.Доступность = Форма.ПравоНаДобавлениеНоменклатурыГТД;
	Форма.Элементы.Комментарий.Доступность = Форма.ПравоНаДобавлениеНоменклатурыГТД И Форма.СоздаватьНоменклатуруГТД;
		
КонецПроцедуры

#КонецОбласти

