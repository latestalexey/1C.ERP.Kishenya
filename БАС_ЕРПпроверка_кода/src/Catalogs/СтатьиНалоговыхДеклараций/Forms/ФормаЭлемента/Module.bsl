#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНалоговойДекларацииПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.Описание.Видимость = (Объект.ВидНалоговойДекларации = ПредопределенноеЗначение("Перечисление.ВидыНалоговыхДеклараций.ДекларацияПоНалогуНаПрибыльНКУ"));	
	
КонецПроцедуры

#КонецОбласти