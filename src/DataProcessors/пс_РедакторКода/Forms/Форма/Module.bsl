&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	пс_Скрипты.ИнициализироватьРедакторКода(Элементы.ХТМЛ);
	РедактируемыйТекст = СтрЗаменить(Параметры.РедактируемыйТекст, Символы.ПС, "\n");
	РедактируемыйТекст = СтрЗаменить(РедактируемыйТекст, Символы.ВК, "\r");
	РедактируемыйТекст = СтрЗаменить(РедактируемыйТекст, "'", "\'");
КонецПроцедуры

&НаКлиенте
Процедура ХТМЛДокументСформирован(Элемент)
	Результат = пс_СкриптыКлиент.ВыполнитьКоманду("monaco.languages.getLanguages()", Элементы.ХТМЛ);
	Для Каждого текЯзык Из Результат Цикл
		Элементы.Язык.СписокВыбора.Добавить(текЯзык.id);
	КонецЦикла;
	Язык = пс_СкриптыКлиент.ВыполнитьКоманду("scriptEdit.getModel().getLanguageIdentifier().language;", Элементы.ХТМЛ);
	пс_СкриптыКлиент.ВыполнитьКоманду(СтрШаблон("scriptEdit.getModel().setValue('%1')", РедактируемыйТекст),
		Элементы.ХТМЛ);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Закрыть(пс_СкриптыКлиент.ВыполнитьКоманду("scriptEdit.getModel().getValue()", Элементы.ХТМЛ));
КонецПроцедуры
&НаКлиенте
Процедура ЯзыкПриИзменении(Элемент)
	пс_СкриптыКлиент.ВыполнитьКоманду(СтрШаблон(
	"monaco.editor.setModelLanguage(scriptEdit.getModel(),'%1')", Язык), Элементы.ХТМЛ);
КонецПроцедуры