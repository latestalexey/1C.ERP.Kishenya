
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Перем ПараметрыФормы;
	
	ПараметрыФормы = Новый Структура("Основание", Новый Структура("МассивВедомостей", ПараметрКоманды));
	
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

