import { Input, Menu, Segment } from "semantic-ui-react";
import Link from "next/link";

const Header = () => {
    return (
      <div style={{marginTop:"20px"}}>
        <Menu pointing>
            <Link href="/changeStatus">
               <Menu.Item name="home">Статус</Menu.Item> 
            </Link>
            <Link href="/">
                <Menu.Item name="messages">Ссылка 2</Menu.Item>
            </Link>
            <Link href="/">
                <Menu.Item name="friends">Ссылка 3</Menu.Item>
            </Link>
            
            <Menu.Menu position="right">
                <Menu.Item>
                    <Input icon="search" placeholder="Search..." />
                </Menu.Item>
                <Link href="/">
                    <Menu.Item name='logout'></Menu.Item>
                </Link>
            </Menu.Menu>
        </Menu>

        {/* <Segment>
          <img src="/images/wireframe/paragraph.png" />
        </Segment> */}
      </div>
    );
}
 
export default Header;