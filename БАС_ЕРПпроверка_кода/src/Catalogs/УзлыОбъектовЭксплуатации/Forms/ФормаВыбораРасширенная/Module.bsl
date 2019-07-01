
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ОбъектЭксплуатации = Параметры.Отбор.Владелец;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("СписокДоступныхУзлов", МассивДоступныхДляВыбораУзлов());
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И Не ТекущиеДанные.ДоступностьВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстПредупреждения = НСтр("ru='Узел ""%Узел%"" недоступен для выбора.
            |Нет доступных показателей наработки'
            |;uk='Вузол ""%Узел%"" недоступний для вибору.
            |Немає доступних показників напрацювання'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Узел%", ТекущиеДанные.Наименование);
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция МассивДоступныхДляВыбораУзлов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр(
		"РегистрацияНаработки",
		Параметры.Свойство("РегистрацияНаработки") И Параметры.РегистрацияНаработки);
	Запрос.УстановитьПараметр(
		"УстановкаНаработки",
		Параметры.Свойство("УстановкаНаработки") И Параметры.УстановкаНаработки);
	Запрос.УстановитьПараметр(
		"ИсточникПоказателяНаработки",
		Параметры.Свойство("ИсточникПоказателяНаработки") И Параметры.ИсточникПоказателяНаработки);
	Запрос.УстановитьПараметр(
		"ПоказательНаработки",
		?(Параметры.Свойство("ПоказательНаработки"), Параметры.ПоказательНаработки, Неопределено));
	Запрос.УстановитьПараметр(
		"ПотребительНаработки",
		?(Параметры.Свойство("ПотребительНаработки"), Параметры.ПотребительНаработки, Неопределено));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПараметрыПоказателейКласса.Ссылка
	|ПОМЕСТИТЬ Классы
	|ИЗ
	|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПараметрыПоказателейКласса
	|ГДЕ
	|	НЕ ПараметрыПоказателейКласса.Ссылка.ПометкаУдаления
	|	И ВЫБОР
	|			КОГДА &РегистрацияНаработки
	|				ТОГДА НЕ ПараметрыПоказателейКласса.РегистрироватьОтИсточника
	|			КОГДА &УстановкаНаработки
	|				ТОГДА ИСТИНА
	|			КОГДА &ИсточникПоказателяНаработки
	|				ТОГДА ПараметрыПоказателейКласса.ПоказательНаработки = &ПоказательНаработки
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Узлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|ГДЕ
	|	Узлы.Ссылка <> &ПотребительНаработки
	|	И Узлы.Класс В
	|			(ВЫБРАТЬ
	|				Классы.Ссылка
	|			ИЗ
	|				Классы КАК Классы)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

