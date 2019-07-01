
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	СписокОпераций = Параметры.СписокОпераций;
	Элементы.СписокОпераций.ВысотаВСтрокахТаблицы = СписокОпераций.Количество();
	
	Элементы.Предупреждение.Видимость = (Параметры.Свойство("ВыводитьПредупреждение") И Параметры.ВыводитьПредупреждение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяОперация = СписокОпераций.НайтиПоЗначению(Элемент.ТекущиеДанные.Значение);
	ТекущаяОперация.Пометка = НЕ ТекущаяОперация.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОповеститьОВыборе(СписокОпераций);
	
КонецПроцедуры

#КонецОбласти