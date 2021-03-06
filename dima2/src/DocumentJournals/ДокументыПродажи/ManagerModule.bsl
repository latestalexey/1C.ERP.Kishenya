
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
КонецПроцедуры

Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеВыполненияРеализацииАкта(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.СписокФорм = "ФормаСписка";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеРасчетовСКлиентомПоДокументам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.МестоРазмещенияКоманды = "ПодменюОтчетыПерейти";
		КомандаОтчет.Порядок = 1;
		КомандаОтчет.СписокФорм = "ФормаСписка";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовСКлиентомПоДокументам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.МестоРазмещенияКоманды = "ПодменюОтчетыПерейти";
		КомандаОтчет.Порядок = 2;
		КомандаОтчет.СписокФорм = "ФормаСписка";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовПоПереданнойВозвратнойТаре(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.Порядок = 3;
		КомандаОтчет.СписокФорм = "ФормаСписка";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуАнализЦенПоставщиковПоДокументу(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.МестоРазмещенияКоманды = "ПодменюОтчетыСмТакже";
		КомандаОтчет.Порядок = 2;
		КомандаОтчет.СписокФорм = "ФормаСписка";
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
