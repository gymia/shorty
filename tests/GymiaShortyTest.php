<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 * PHPUnit Tests
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @link        https://github.com/sebastianbergmann/phpunit/blob/master/src/Framework/Assert.php
 *
 * @since       Wednesday, September 24, 2014 / 06:15 PM GMT+1
 * @edited      $Date$
 * @version     $Id$
 *
 * @package     Gymia Pre-Job Test
 * @category    Pre-Job Tests
 * 
 * @uses        PHPUnit
*/

require_once( dirname( dirname( __FILE__ ) ).'/application/config/bootstrap.php' ); 
class GymiaShortyTest extends PHPUnit_Framework_TestCase
{
    public function testCustomShortCode()
    {
        $pattern    = '^[0-9a-zA-Z_]{4,}';
        $shortCode  = 'example';

        $this->assertNotEmpty( preg_match('/'.$pattern.'/', $shortCode ) );
    }
}